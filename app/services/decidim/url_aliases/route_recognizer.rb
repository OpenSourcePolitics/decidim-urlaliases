# frozen_string_literal: true

module Decidim
  module UrlAliases
    class RouteRecognizer
      VALID_SOURCE_REGEX = %r{\A/[0-9a-zA-Z_\-]+\z}
      NEW_RESERVED_PATHS = %w().freeze unless const_defined?(:NEW_RESERVED_PATHS)
      WHITELISTED_PREFIXES = %w(/uploads).freeze unless const_defined?(:WHITELISTED_PREFIXES)

      def matching_path?(request_path)
        return true if request_path.starts_with?(*WHITELISTED_PREFIXES)

        space_paths.any? { |path| path.match(request_path) }
      end

      def reserved_path?(request_path)
        reserved_paths.include?(request_path)
      end

      private

      # Return an Array[String].
      def reserved_paths
        NEW_RESERVED_PATHS + core_paths + verifications_paths + space_index_paths
      end

      # Return an Array[String].
      def core_paths
        @core_paths ||= begin
          paths = Decidim::Core::Engine.routes.routes.map(&route_to_s)
          paths.select(&select_root_paths).map(&remove_format).uniq
        end
      end

      # Return an Array[String].
      def verifications_paths
        @verifications_paths ||= begin
          paths = Decidim::Verifications::Engine.routes.routes.map(&route_to_s)
          paths.select(&select_root_paths).map(&remove_format).uniq
        end
      end

      # Return an Array[String].
      def space_index_paths
        @space_index_paths ||= begin
          space_names = space_manifests.map(&:name).map(&:to_s)
          index_routes = space_routes.select { |route| route.name.in?(space_names) }
          index_routes.map(&route_to_s).map(&remove_format)
        end
      end

      # Return a Proc.
      def remove_format
        proc { |string| string.remove("(.:format)") }
      end

      # Return a Proc.
      def route_to_s
        proc { |route| route.path.spec.to_s }
      end

      # Return a Proc.
      def select_root_paths
        proc do |path|
          VALID_SOURCE_REGEX.match(path) ||
            path.count("/") == 1 && path.include?("(.:format)")
        end
      end

      # Returns an Array[ParticipatorySpaceManifest].
      def space_manifests
        Decidim.participatory_space_manifests
      end

      # Return an Array[ActionDispatch::Journey::Path::Pattern].
      def space_paths
        @space_paths ||= space_routes.map(&:path)
      end

      # Return an Array[ActionDispatch::Journey::Route].
      def space_routes
        @space_routes ||= space_manifests.map do |manifest|
          engine = manifest.context.engine
          engine.routes.routes
        end.map(&:routes).flatten
      end
    end
  end
end
