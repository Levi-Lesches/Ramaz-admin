import "package:flutter/material.dart";

typedef ModelBuilder<T> = T Function();
typedef ModelWidgetBuilder<T, U> = Widget Function(T, Widget, U);

class ModelListener<Model extends ChangeNotifier, UIModel> extends StatefulWidget {
	final ModelBuilder<Model> model;
	final ModelWidgetBuilder<Model, UIModel> builder;
	final ModelBuilder<UIModel> uiModel;
	final Widget child;

	final bool dispose;

	const ModelListener({
		@required this.model,
		@required this.builder,
		this.child,
		this.dispose = true,
		this.uiModel,
	});

	ModelListenerState<Model, UIModel> createState() => ModelListenerState<Model, UIModel>();
}

class ModelListenerState<Model extends ChangeNotifier, UIModel> extends State<ModelListener<Model, UIModel>> {
	Model model;
	UIModel uiModel;

	void listener() => setState(() {});

	@override 
	void initState() {
		super.initState();
		model = widget.model();
		model.addListener(listener);
		if (widget.uiModel != null) uiModel = widget.uiModel();
	}

	@override
	Widget build(BuildContext context) => 
		widget.builder(model, widget.child, uiModel);

	@override 
	void dispose() {
		model.removeListener(listener);
		if (widget.dispose) model.dispose();
		super.dispose();
	}
}
