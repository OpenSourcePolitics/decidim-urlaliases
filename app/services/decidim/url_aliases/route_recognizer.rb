# frozen_string_literal: true

module Decidim
  module UrlAliases
    class RouteRecognizer
      VALID_SOURCE_REGEX = %r{/[0-9a-zA-Z_\-]+\z}
      RESERVED_PATHS = %w(/admin /api /system).freeze

      def matching_path?(request_path)
        paths.any? { |path| path.match(request_path) }
      end

      def reserved_path?(request_path)
        reserved_paths.include?(request_path)
      end

      private

      def reserved_paths
        RESERVED_PATHS + index_paths
      end

      # Return an Array[String].
      def index_paths
        @index_paths ||= begin
          manifest_names = manifests.map(&:name).map(&:to_s)
          index_routes = routes.select { |route| route.name.in?(manifest_names) }
          index_paths = index_routes.map { |route| route.path.spec.to_s }
          index_paths.map { |path| path.remove("(.:format)") }
        end
      end

      # Returns an Array[ParticipatorySpaceManifest].
      def manifests
        Decidim.participatory_space_manifests
      end

      # Return an Array[ActionDispatch::Journey::Path::Pattern].
      def paths
        @paths ||= routes.map(&:path)
      end

      # Return an Array[ActionDispatch::Journey::Route].
      def routes
        @routes ||= manifests.map do |manifest|
          engine = manifest.context.engine
          engine.routes.routes
        end.map(&:routes).flatten
      end
    end
  end
end
