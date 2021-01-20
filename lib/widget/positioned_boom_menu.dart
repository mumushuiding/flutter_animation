import 'package:flutter/material.dart';

class PositionedBoomMenu extends StatefulWidget {
  // Children buttons, from the lowest to the highest.
  final List<BoomMenuItem> children;

  /// Used to get the button hidden on scroll. See examples for more info.
  final bool scrollVisible;

  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final ShapeBorder fabMenuBorder;
  final Alignment alignment;

  final double marginLeft;
  final double marginRight;
  final double marginBottom;

  final double fabPaddingLeft;
  final double fabPaddingRight;
  final double fabPaddingTop;
  // 距离顶上绝对距离
  final double top;
  // 距离左边绝对距离
  final double left;

  /// The color of the background overlay.
  final Color overlayColor;

  /// The opacity of the background overlay when the dial is open.
  final double overlayOpacity;

  /// The animated icon to show as the main button child. If this is provided the [child] is ignored.
  final AnimatedIconData animatedIcon;

  /// The theme for the animated icon.
  final IconThemeData animatedIconTheme;

  /// The child of the main button, ignored if [animatedIcon] is non [null].
  final Widget child;

  /// Executed when the dial is opened.
  final VoidCallback onOpen;

  /// Executed when the dial is closed.
  final VoidCallback onClose;

  /// Executed when the dial is pressed. If given, the dial only opens on long press!
  final VoidCallback onPress;

  /// If true user is forced to close dial manually by tapping main button. WARNING: If true, overlay is not rendered.
  final bool overlayVisible;

  /// The speed of the animation
  final int animationSpeed;

  final String title;
  final String subtitle;
  final Color titleColor;
  final Color subTitleColor;

  PositionedBoomMenu(
      {this.children = const [],
      this.scrollVisible = true,
      this.title,
      this.subtitle,
      this.backgroundColor,
      this.titleColor,
      this.subTitleColor,
      this.foregroundColor,
      this.elevation = 6.0,
      this.overlayOpacity = 0.8,
      this.overlayColor = Colors.white,
      this.animatedIcon,
      this.animatedIconTheme,
      this.child,
      this.marginBottom = 0,
      this.marginLeft = 16,
      this.marginRight = 0,
      this.onOpen,
      this.onClose,
      this.overlayVisible = false,
      this.fabMenuBorder = const CircleBorder(),
      this.alignment = Alignment.centerRight,
      this.fabPaddingRight = 0,
      this.fabPaddingLeft = 0,
      this.fabPaddingTop = 0,
      this.onPress,
      this.top = 100,
      this.left = 100,
      this.animationSpeed = 150});
  @override
  State<StatefulWidget> createState() {
    return _BoomMenuState();
  }
}

class _BoomMenuState extends State<PositionedBoomMenu> with SingleTickerProviderStateMixin {
  AnimationController controller;
  bool _open = false;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = AnimationController(duration: _calculateMainControllerDuration(), vsync: this);
    super.initState();
  }

  Duration _calculateMainControllerDuration() =>
      Duration(milliseconds: widget.animationSpeed + widget.children.length * (widget.animationSpeed / 5).round());
  void __performAnimation() {
    if (!mounted) return;
    if (_open) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  void didUpdateWidget(PositionedBoomMenu oldWidget) {
    if (oldWidget.children.length != widget.children.length) {
      controller.duration = _calculateMainControllerDuration();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _toggleChildren() {
    var newValue = !_open;
    setState(() {
      _open = newValue;
    });
    if (newValue && widget.onOpen != null) widget.onOpen();
    __performAnimation();
    if (!newValue && widget.onClose != null) widget.onClose();
  }

  Widget _renderOverlay() {
    return Positioned(
      right: -16,
      bottom: -16,
      top: _open ? 0 : null,
      left: _open ? 0.0 : null,
      child: GestureDetector(
        onTap: _toggleChildren,
        child: BackgroundOverlay(animation: controller, color: widget.overlayColor, opacity: widget.overlayOpacity),
      ),
    );
  }

  Widget _renderButton() {
    var child = widget.animatedIcon != null
        ? AnimatedIcon(
            icon: widget.animatedIcon,
            progress: controller,
            color: widget.animatedIconTheme?.color,
            size: widget.animatedIconTheme?.size,
          )
        : widget.child;
    var fabChildren = _getChildrenList();
    var animatedFloatingButton = AnimatedFloatingButton(
        visible: widget.scrollVisible,
        backgroundColor: widget.backgroundColor,
        foregroundColor: widget.foregroundColor,
        elevation: widget.elevation,
        onLongPress: _toggleChildren,
        callback: (_open || widget.onPress == null) ? _toggleChildren : widget.onPress,
        child: child,
        shape: widget.fabMenuBorder);
    return Positioned(
      left: widget.marginLeft + 16,
      bottom: widget.marginBottom,
      right: widget.marginRight,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: kToolbarHeight + 40,
            ),
            Visibility(
              visible: _open,
              child: Container(
                height: fabChildren.length * 100.0,
                constraints: BoxConstraints(maxWidth: 400),
                child: ListView(
                  children: List.from(fabChildren),
                  reverse: true,
                ),
              ),
            ),
            Visibility(
              visible: _open,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(
                    left: widget.fabPaddingLeft,
                    right: widget.fabPaddingRight,
                    top: 8.0 + widget.fabPaddingTop,
                  ),
                  child: animatedFloatingButton,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getChildrenList() {
    final singleChildrenTween = 1.0 / widget.children.length;
    return widget.children
        .map<Widget>((BoomMenuItem child) {
          int index = widget.children.indexOf(child);
          var childAnimation = Tween(begin: 0.0, end: 62.0).animate(CurvedAnimation(
            parent: this.controller,
            curve: Interval(0, singleChildrenTween * (index + 1)),
          ));
          return BoomMenuAnimatedChild(
              animation: childAnimation,
              index: index,
              visible: _open,
              backgroundColor: child.backgroundColor,
              elevation: child.elevation,
              child: child.child,
              title: child.title,
              subtitle: child.subtitle,
              titleColor: child.titleColor,
              subTitleColor: child.subTitleColor,
              onTap: child.onTap,
              toggleChildren: () {
                if (!widget.overlayVisible) _toggleChildren();
              });
        })
        .toList()
        .reversed
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var child = widget.animatedIcon != null
        ? AnimatedIcon(
            icon: widget.animatedIcon,
            progress: controller,
            color: widget.animatedIconTheme?.color,
            size: widget.animatedIconTheme?.size,
          )
        : widget.child;
    var animatedFloatingButton = AnimatedFloatingButton(
        visible: widget.scrollVisible,
        backgroundColor: widget.backgroundColor,
        foregroundColor: widget.foregroundColor,
        elevation: widget.elevation,
        onLongPress: _toggleChildren,
        callback: (_open || widget.onPress == null) ? _toggleChildren : widget.onPress,
        child: child,
        shape: widget.fabMenuBorder);
    List<Widget> children = [
      !widget.overlayVisible ? _renderOverlay() : Container(),
      _renderButton(),
      Positioned(
        top: widget.top,
        left: widget.left,
        child: animatedFloatingButton,
      ),
    ];

    return Stack(
      alignment: Alignment.topLeft,
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: children,
    );
  }
}

class BoomMenuItem {
  final Widget child;
  final Color backgroundColor;
  final double elevation;
  final VoidCallback onTap;
  final String title;
  final String subtitle;
  final Color titleColor;
  final Color subTitleColor;

  BoomMenuItem(
      {this.child,
      @required this.title,
      this.subtitle,
      this.backgroundColor,
      this.elevation,
      this.onTap,
      this.titleColor,
      this.subTitleColor});
}

class BoomMenuAnimatedChild extends AnimatedWidget {
  final int index;
  final Color backgroundColor;
  final double elevation;
  final Widget child;

  final bool visible;
  final VoidCallback onTap;
  final VoidCallback toggleChildren;
  final String title;
  final String subtitle;
  final Color titleColor;
  final Color subTitleColor;

  BoomMenuAnimatedChild(
      {Key key,
      Animation<double> animation,
      this.index,
      this.backgroundColor,
      this.elevation = 6.0,
      this.child,
      this.title,
      this.subtitle,
      this.visible = false,
      this.onTap,
      this.toggleChildren,
      this.titleColor,
      this.subTitleColor})
      : super(key: key, listenable: animation);
  void _performAction() {
    if (onTap != null) onTap();
    toggleChildren();
  }

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    final Widget buttonChild = animation.value > 50.0
        ? Container(
            width: animation.value,
            height: animation.value,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: child ?? Container(),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: titleColor ?? Colors.black, fontSize: 16.0),
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          subtitle,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: subTitleColor ?? Colors.black, fontSize: 12.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container();
    return Container(
      // width: MediaQuery.of(context).size.width - 30,
      width: 100,
      height: 80.0,
      padding: EdgeInsets.only(bottom: 72 - animation.value),
      child: GestureDetector(
        onTap: _performAction,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
          color: backgroundColor,
          child: buttonChild,
        ),
      ),
    );
  }
}

class BackgroundOverlay extends AnimatedWidget {
  final Color color;
  final double opacity;
  BackgroundOverlay({Key key, Animation<double> animation, this.color = Colors.white, this.opacity = 0.8})
      : super(key: key, listenable: animation);
  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Container(
      color: color.withOpacity(animation.value * opacity),
    );
  }
}

class AnimatedFloatingButton extends StatelessWidget {
  final bool visible;
  final VoidCallback callback;
  final VoidCallback onLongPress;
  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final String tooltip;
  final String heroTag;
  final double elevation;
  final ShapeBorder shape;
  final Curve curve;

  AnimatedFloatingButton({
    this.visible = true,
    this.callback,
    this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
    this.heroTag,
    this.elevation = 6.0,
    this.shape = const CircleBorder(),
    this.curve = Curves.linear,
    this.onLongPress,
  });
  @override
  Widget build(BuildContext context) {
    var margin = visible ? 0.0 : 28.0;
    return Container(
      constraints: BoxConstraints(minHeight: 0.0, minWidth: 0.0),
      width: 56.0,
      height: 56.0,
      child: AnimatedContainer(
        curve: curve,
        margin: EdgeInsets.all(margin),
        duration: Duration(milliseconds: 150),
        width: visible ? 56 : 0,
        height: visible ? 56 : 0,
        child: GestureDetector(
          onLongPress: onLongPress,
          child: FloatingActionButton(
            onPressed: onLongPress,
            child: visible ? child : null,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            tooltip: tooltip,
            heroTag: heroTag,
            elevation: elevation,
            highlightElevation: elevation,
            shape: shape,
          ),
        ),
      ),
    );
  }
}
