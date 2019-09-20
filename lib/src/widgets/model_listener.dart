import "package:flutter/material.dart";

typedef ModelBuilder<T> = T Function();
typedef ModelWidgetBuilder<T> = Widget Function(BuildContext, T, Widget);

class ModelListener<Model extends ChangeNotifier> extends StatefulWidget {
	final ModelBuilder<Model> model;
	final ModelWidgetBuilder<Model> builder;
	final Widget child;

	final bool dispose;

	const ModelListener({
		@required this.model,
		@required this.builder,
		this.child,
		this.dispose = true,
	});

	@override
	ModelListenerState<Model> createState() => 
		ModelListenerState<Model>();
}

class ModelListenerState<Model extends ChangeNotifier> 
extends State<ModelListener<Model>> {
	Model model;

	void listener() => setState(() {});

	@override 
	void initState() {
		super.initState();
		model = widget.model()
			..addListener(listener);
	}

	@override
	Widget build(BuildContext context) => 
		widget.builder(context, model, widget.child);

	@override 
	void dispose() {
		model.removeListener(listener);
		if (widget.dispose) {
			model.dispose();
		}
		super.dispose();
	}
}
