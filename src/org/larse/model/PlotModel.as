package org.larse.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	import org.larse.events.PlotEvent;
	import org.larse.vos.Plot;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	
	[Event(name="get_all_plots",type="org.larse.events.PlotEvent")]
	[Event(name="plot_selection_changed",type="org.larse.events.PlotEvent")]
	[Event(name="plot_model_changed",type="org.larse.events.PlotEvent")]
	[Event(name="plot_spectral_loaded",type="org.larse.events.PlotEvent")]
	[Event(name="plot_modified",type="org.larse.events.PlotEvent")]
	[Event(name="show_history",type="org.larse.events.PlotEvent")]
	[ManagedEvents("plot_modified,plot_spectral_loaded,get_all_plots,plot_selection_changed,plot_model_changed,show_history,load_verteices")]
	public class PlotModel extends EventDispatcher
	{
		private var _plots:ArrayCollection = new ArrayCollection();
		private var _sample:Plot;
		private var _plotSize:int = 1; //number of pixels
		
		//decimal points for display
		public var scale:int = 1000;
		
		/*** Class Attributes ***/
		[Bindable]
		public function get Plots():ArrayCollection
		{
			return _plots;
		}
		
		public function set Plots(value:ArrayCollection):void
		{
			_plots = value;
			dispatchEvent(new PlotEvent(PlotEvent.PLOT_MODEL_CHANGED, null));
		}
		
		public function get plotSize():int {
			return _plotSize;
		}
		
		public function set plotSize(value:int):void {
			_plotSize = value;
		}
		
		[Bindable]
		public function get currentPlot():Plot
		{
			return _sample;
		}
		
		public function set currentPlot(value:Plot):void
		{
			_sample = value;
			dispatchEvent(new PlotEvent(PlotEvent.PLOT_SELECTION_CHANGED, _sample));
		}
		
		public function plotSelectionChanged():void {
			dispatchEvent(new PlotEvent(PlotEvent.PLOT_SELECTION_CHANGED, _sample));
		}
		
		public function plotSpectralLoaded():void {
			dispatchEvent(new PlotEvent(PlotEvent.PLOT_SPECTRAL_LOADED, _sample));	
		}
		
		//this is only for when data loaded from database
		public function plotModified():void {
			dispatchEvent(new PlotEvent(PlotEvent.PLOT_MODIFIED));
		}
		
		public function plotHistoryLoaded():void {
			dispatchEvent(new PlotEvent(PlotEvent.SHOW_HISTORY));
		}
		
		public function reLoadVertex():void {
			if (_sample!=null)
				dispatchEvent(new PlotEvent(PlotEvent.LOAD_VERTEX, _sample));
		}
	}
}