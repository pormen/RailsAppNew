class LdController < ApplicationController
	#load_and_authorize_resource

	def index

		@asformulary = Asformulary.new(:rut_atendido => params[:rut_atendido])
		
	end


	def crudpannel
	end

	def beneficiospannel
	end

	def reportspannel

		@obra = Obra.new
		@asformulary = Asformulary.new

		if params[:asformulary] && params[:asformulary][:rut_atendido]
			@benefitslog = Logbenefitsfinal.where(ruttrabajador: params[:asformulary][:rut_atendido]).order('created_at DESC')
		end

		#puts params[:obra][:id]

		if params[:obra] && params[:obra][:id] && params[:event1] && params[:event2]

			Rails.application.config.obra = params[:obra]
			Rails.application.config.obraId = params[:obra][:id]
			Rails.application.config.event1 = params[:event1]
			Rails.application.config.event2 = params[:event2]


			if params[:event1]["date(2i)"] != "10" && params[:event1]["date(2i)"] != "11" && params[:event1]["date(2i)"] != "12"
				Rails.application.config.fecha1 = params[:event1]["date(1i)"] + "-" + "0" + params[:event1]["date(2i)"] + "-" + "01"
			else
				Rails.application.config.fecha1 = params[:event1]["date(1i)"]+ "-" + params[:event1]["date(2i)"]+ "-" + "01"
			end
			if params[:event2]["date(2i)"] != "10" && params[:event2]["date(2i)"] != "11" && params[:event2]["date(2i)"] != "12"
				Rails.application.config.fecha2 =params[:event2]["date(1i)"]+ "-" + "0" + params[:event2]["date(2i)"]+ "-" + "31"
			else
			    Rails.application.config.fecha2 =params[:event2]["date(1i)"]+ "-" + params[:event2]["date(2i)"]+ "-" + "31"
			end


		end


		respond_to do |format|
        
        format.pdf {
          render pdf: "Reportes",
          template: "layouts/reportsPannelLog"
        }
        format.html




	end


	def download_pdf
		#@assignbenefit = Rails.application.config.ab
    	
        pdf = WickedPdf.new.pdf_from_string(
		render_to_string('layouts/reportsPannelLog.pdf.erb', layout: false)
		)

		send_data pdf, :filename => "Reportes.pdf", :type => "application/pdf",:disposition => "attachment"

    	end
    end




	def userspannel
		
		if params[:registrar]

			

			if params[:ld][:id] != ""
				ob = Obra.find(params[:ld][:id]).codigo
			else
				ob = ""
			end



			asocial_role = false
			ao_role = false
			administrativo_obra_role = false
			subgerente_personas_role = false
			jefe_remuneraciones_role = false


			if params[:ld][:role] == "asocial_role"
				asocial_role = true
			elsif params[:ld][:role] == "ao_role"
				ao_role = true
			elsif params[:ld][:role] == "administrativo_obra_role"
				administrativo_obra_role = true
			elsif params[:ld][:role] == "subgerente_personas_role"
				subgerente_personas_role = true
			elsif params[:ld][:role] == "jefe_remuneraciones_role"
				jefe_remuneraciones_role = true		
			end



		Lyduser.create(obra: ob,email: params[:ld][:email], password: params[:ld][:password], password_confirmation: params[:ld][:password_confirmation], nombre_usuario: params[:ld][:nombre_usuario], admin_role: 0, asocial_role: asocial_role, ao_role: ao_role, administrativo_obra_role: administrativo_obra_role, subgerente_personas_role: subgerente_personas_role, jefe_remuneraciones_role: jefe_remuneraciones_role)
		redirect_to ld_userspannel_path

		elsif params[:cambiarPass]

			if params[:ld][:id] != ""
				us = Lyduser.find(params[:ld][:id])
			else
				us = ""
			end

			us.update_attributes(password: params[:ld][:password])





		elsif params[:cambiarObra]
			
			if params[:ld][:o_id] != ""
				ob = Obra.find(params[:ld][:o_id]).codigo
			else
				ob = ""
			end

			if params[:ld][:u_id] != ""
				us = Lyduser.find(params[:ld][:u_id])
			else
				us = ""
			end

			us.update_attributes(obra: ob)




		elsif params[:desactivarUsuario]

			if params[:ld][:id] && current_lyduser.admin_role?

				us = Lyduser.find(params[:ld][:id])

				if us.is_active?
					us.update_attributes(is_active: false)
				else
					us.update_attributes(is_active: true)
				end


			end


			


			

		end
	
	 	 
		
	end

end