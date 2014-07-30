package org.larse.controllers
{
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	
	import org.larse.events.PlotEvent;
	import org.larse.model.GlobalModel;
	import org.larse.model.PlotModel;
	import org.larse.services.TimeSyncService;
	import org.larse.vos.Plot;
	import org.larse.vos.Vertex;
	
	
	/**
	 * Load vertex history
	 * 
	 * This command implements almost identifical behavior as PlotVertexLoadCommand.
	 * The main difference is when data return, where to load the data on the UI. This
	 * function could be combined with PlotVertexLoadCommand with a boolean flag for 
	 * whether it is for history or regular. But it is not a good design.
	 * 
	 */
	public class PlotVertexHistoryLoadCommand
	{
		[Inject] public var service:TimeSyncService;
		[Inject] public var plotModel:PlotModel;
		[Inject] public var global:GlobalModel;
		
		private var _plot:Plot = null;
		
		public function PlotVertexHistoryLoadCommand() {}
		
		public function execute(event:PlotEvent):AsyncToken
		{
			_plot = event.CurrentPlot;
			
			var history:int = 1;
			
			trace("PlotVertexHistoryLoadCommand.execute()");
			if (global.project_id > 0 && global.tsa > 0) {
				return service.loadVerticesForPlot(global.project_id, global.tsa, _plot.plotid, global.interpreter.user_id, history);
			}
			else
				return null;
		}
		
		public function result(list:ArrayCollection):void
		{
			trace("PlotVertexHistoryLoadCommand.result()");
			if (list.length>0) {
				_plot.historyVertices = list;
			}
			plotModel.plotHistoryLoaded();
//				_plot.vertices = list;
//				var v:Vertex = list.getItemAt(0) as Vertex;
//				global.examinee_id = v.interpreter;
//			}
//			_plot.isVertexLoaded = true;
//			plotModel.plotModified();
//			plotModel.plotSpectralLoaded(); //force to redraw trajectory
		}
		
		public function error(fault:FaultEvent):void
		{
			trace(fault.message.toString());
			Alert.show("Database had an error", "Load Plot Vertex History Error");
		}
	}
}