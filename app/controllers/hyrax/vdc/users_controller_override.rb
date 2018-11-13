# Attempting to override from Hyrax Gem 2.0.0:                                                          #   app/controllers/hyrax/users_controller.rb
#
#   index: add approved where clause
#   edit: temporarily to turn off edit functionality until we're ready to put it back
#   update: temporarily to turn off edit functionality until we're ready to put it back
#   show: enable very basic content negotiation

module Hyrax
  module Vdc
    module UsersControllerOverride
      def index
        @users = search(params[:uq]).where(approved: true)
      end
      
      def update
        # TODO: put functionality back eventually
        flash[:notice] = "Profile updating has been temporarily disabled."
      end    

      # TODO: Follow the example for the works controller and create a presenter
      #       to encapsulate the content negotiation better
      # NOTE: Attempting simple content negotiation to support jsonld, ttl formats at least.
      # TODO: Use something like GraphExporter with the solr document and then dump?
      #       Not sure yet how that works, but it's probably more efficient.
      def show
        respond_to do |wants|
          wants.html { super }
          wants.jsonld do 
            render body: "{ \"@graph\": #{::Vdc::Person.find(@user.identifier_system).resource.dump(:jsonld)} }", content_type: 'application/json'
          end
          wants.ttl do
            render body: ::Vdc::Person.find(@user.identifier_system).resource.dump(:ttl), content_type: 'text/turtle'
          end
        end
      end
    end
  end
end
