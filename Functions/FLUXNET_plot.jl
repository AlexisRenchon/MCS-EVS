using WGLMakie, JSServe

function FNplot(slider)
	fig = Figure()
	# slider = Slider(fig[1, 1], range = 1:5)
	ax = Axis(fig[2, 1])	
	site_n = slider.value
	data = @lift(Point2f0.(dropmissing(loadFLUXNET(ID[$site_n]), [:SW_IN_POT, :GPP_DT_CUT_50]).SW_IN_POT, 
		               dropmissing(loadFLUXNET(ID[$site_n]), [:SW_IN_POT, :GPP_DT_CUT_50]).GPP_DT_CUT_50)) 	
	p = plot!(ax, data)
	return fig
end

app = App() do session::Session    
	slider = JSServe.Slider(1:5)
	fig = FNplot(slider)    
	sl = DOM.div("FLUXNET site: ", slider, slider.value)
	return JSServe.record_states(session, DOM.div(sl, fig))
end


