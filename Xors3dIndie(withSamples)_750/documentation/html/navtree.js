var NAVTREE =
[
  [ "Xors3d Engine", "index.html", [
    [ "Main Page", "index.html", [
      [ "Getting Started Programming With Xors3d", "getting_started.html", [
        [ "Downloading and Updating", "getting_started_download_update.html", null ],
        [ "Installation", "getting_started_install.html", null ],
        [ "Hello 3D World", "getting_started_hello_world.html", null ]
      ] ],
      [ "Splash Screen", "splash_screen.html", null ],
      [ "Changelog", "main_changelog.html", null ]
    ] ],
    [ "Related Pages", "pages.html", [
      [ "Deprecated List", "deprecated.html", null ]
    ] ],
    [ "Modules", "modules.html", [
      [ "Command reference", "group__comref.html", [
        [ "3D Lines", "group__lines3d.html", null ],
        [ "3D maths", "group__mathcommands.html", null ],
        [ "Audio", "group__audiocommands.html", null ],
        [ "Brushes", "group__brushcommands.html", null ],
        [ "Cameras", "group__camcommands.html", null ],
        [ "Entity animation", "group__eacommands.html", null ],
        [ "Entity collision", "group__ecolcommands.html", null ],
        [ "Entity control", "group__eccommands.html", null ],
        [ "Entity movement", "group__emcommands.html", null ],
        [ "Entity state", "group__escommands.html", null ],
        [ "File System", "group__fscommands.html", null ],
        [ "Graphics", "group__maincommands.html", null ],
        [ "Images", "group__imagecommands.html", null ],
        [ "Input", "group__incommands__generic.html", [
          [ "Joystick", "group__joycommands.html", null ],
          [ "Keyboard", "group__keycommands.html", null ],
          [ "Mouse", "group__mousecommands.html", null ]
        ] ],
        [ "Lights", "group__lightcommands.html", null ],
        [ "Logging", "group__logcommands.html", null ],
        [ "Meshes", "group__meshcommands.html", null ],
        [ "Particle systems", "group__psyscommands__generic.html", [
          [ "Emitters", "group__pemittercommands.html", null ],
          [ "Particle", "group__pparticlecommands.html", null ],
          [ "Particle systems", "group__psyscommands.html", null ]
        ] ],
        [ "Physics", "group__pxcommands.html", [
          [ "Contacts", "group__px__contacts.html", null ],
          [ "Etc", "group__px__etc.html", null ],
          [ "Filtering", "group__px__filter.html", null ],
          [ "Force and impulse", "group__px__force__imp.html", null ],
          [ "Gravity", "group__px__gravity.html", null ],
          [ "Joints", "group__px__joints.html", null ],
          [ "Local transformation", "group__px__local__trans.html", null ],
          [ "Parameters", "group__px__params.html", null ],
          [ "Raycasting", "group__px__raycast.html", null ],
          [ "Shapes", "group__px__shapes.html", [
            [ "Compound", "group__px__shapes__compounds.html", null ]
          ] ],
          [ "Sleeping", "group__px__sleep.html", null ],
          [ "Vehicle", "group__px__vehicle.html", null ],
          [ "Velocity", "group__px__velocity.html", null ]
        ] ],
        [ "Post-effects", "group__posteffectcommands.html", null ],
        [ "Shaders effects", "group__shadercommands.html", null ],
        [ "Shadows", "group__shadowcommands.html", null ],
        [ "Sprites", "group__sprcommands.html", null ],
        [ "Surfaces", "group__surfcommands.html", null ],
        [ "System information", "group__sicommands.html", null ],
        [ "Terrains", "group__terrcommands.html", null ],
        [ "Text drawing", "group__textcommands.html", null ],
        [ "Textures", "group__texcommands.html", null ],
        [ "Video playback", "group__videocommands.html", null ],
        [ "Worlds", "group__worldcommands.html", null ]
      ] ],
      [ "Constants", "group__constref.html", [
        [ "Animation playback types", "group__animtypes.html", null ],
        [ "AntiAliasing types", "group__aatypes.html", null ],
        [ "Axis", "group__axistypes.html", null ],
        [ "Blending modes", "group__entblendtypes.html", null ],
        [ "Camera projection types", "group__projtypes.html", null ],
        [ "Collision types", "group__colltypes.html", null ],
        [ "Compare functions", "group__cmpfunc.html", null ],
        [ "Cubemap faces", "group__facetypes.html", null ],
        [ "Cubemap rendering modes", "group__cubemodes.html", null ],
        [ "FX flags", "group__fxflags.html", null ],
        [ "Fog types", "group__fogtypes.html", null ],
        [ "Joint types", "group__jointtypes.html", null ],
        [ "Joystick types", "group__joytypes.html", null ],
        [ "Light types", "group__lighttypes.html", null ],
        [ "Line separtor types", "group__lstypes.html", null ],
        [ "Logging level", "group__loglevels.html", null ],
        [ "Logging output targets", "group__logtargets.html", null ],
        [ "Matrix semantics", "group__mtxsemantic.html", null ],
        [ "Physics debug drawer modes", "group__px_d_d_modes.html", null ],
        [ "Physics raycasting modes", "group__px_r_c_modes.html", null ],
        [ "Picking types", "group__picktypes.html", null ],
        [ "Pixel Shaders versions", "group__psversions.html", null ],
        [ "Response types", "group__resptypes.html", null ],
        [ "Skinning methods", "group__skinmethods.html", null ],
        [ "Sprite view modes", "group__sviewmodes.html", null ],
        [ "Texture filtering types", "group__texfilters.html", null ],
        [ "Texture loading flags", "group__tlflags.html", null ],
        [ "Textures blending types (fixed-function pipeline)", "group__texblendtypes.html", null ],
        [ "The levels of blur for the shadows.", "group__shadowsblur.html", null ],
        [ "The types of primitive for rendering of meshes and surfaces", "group__primitivetypes.html", null ],
        [ "Vertex Shaders versions", "group__vsversions.html", null ]
      ] ],
      [ "Engine Settings", "group__enginesetref.html", null ],
      [ "Semantics", "group__semanticsref.html", [
        [ "Matrix semantics", "group__se__mtxsemantic.html", null ],
        [ "Non-matrix semantics", "group__se__nonmtxsemantic.html", null ]
      ] ]
    ] ]
  ] ]
];

function createIndent(o,domNode,node,level)
{
  if (node.parentNode && node.parentNode.parentNode)
  {
    createIndent(o,domNode,node.parentNode,level+1);
  }
  var imgNode = document.createElement("img");
  if (level==0 && node.childrenData)
  {
    node.plus_img = imgNode;
    node.expandToggle = document.createElement("a");
    node.expandToggle.href = "javascript:void(0)";
    node.expandToggle.onclick = function() 
    {
      if (node.expanded) 
      {
        $(node.getChildrenUL()).slideUp("fast");
        if (node.isLast)
        {
          node.plus_img.src = node.relpath+"ftv2plastnode.png";
        }
        else
        {
          node.plus_img.src = node.relpath+"ftv2pnode.png";
        }
        node.expanded = false;
      } 
      else 
      {
        expandNode(o, node, false);
      }
    }
    node.expandToggle.appendChild(imgNode);
    domNode.appendChild(node.expandToggle);
  }
  else
  {
    domNode.appendChild(imgNode);
  }
  if (level==0)
  {
    if (node.isLast)
    {
      if (node.childrenData)
      {
        imgNode.src = node.relpath+"ftv2plastnode.png";
      }
      else
      {
        imgNode.src = node.relpath+"ftv2lastnode.png";
        domNode.appendChild(imgNode);
      }
    }
    else
    {
      if (node.childrenData)
      {
        imgNode.src = node.relpath+"ftv2pnode.png";
      }
      else
      {
        imgNode.src = node.relpath+"ftv2node.png";
        domNode.appendChild(imgNode);
      }
    }
  }
  else
  {
    if (node.isLast)
    {
      imgNode.src = node.relpath+"ftv2blank.png";
    }
    else
    {
      imgNode.src = node.relpath+"ftv2vertline.png";
    }
  }
  imgNode.border = "0";
}

function newNode(o, po, text, link, childrenData, lastNode)
{
  var node = new Object();
  node.children = Array();
  node.childrenData = childrenData;
  node.depth = po.depth + 1;
  node.relpath = po.relpath;
  node.isLast = lastNode;

  node.li = document.createElement("li");
  po.getChildrenUL().appendChild(node.li);
  node.parentNode = po;

  node.itemDiv = document.createElement("div");
  node.itemDiv.className = "item";

  node.labelSpan = document.createElement("span");
  node.labelSpan.className = "label";

  createIndent(o,node.itemDiv,node,0);
  node.itemDiv.appendChild(node.labelSpan);
  node.li.appendChild(node.itemDiv);

  var a = document.createElement("a");
  node.labelSpan.appendChild(a);
  node.label = document.createTextNode(text);
  a.appendChild(node.label);
  if (link) 
  {
    a.href = node.relpath+link;
  } 
  else 
  {
    if (childrenData != null) 
    {
      a.className = "nolink";
      a.href = "javascript:void(0)";
      a.onclick = node.expandToggle.onclick;
      node.expanded = false;
    }
  }

  node.childrenUL = null;
  node.getChildrenUL = function() 
  {
    if (!node.childrenUL) 
    {
      node.childrenUL = document.createElement("ul");
      node.childrenUL.className = "children_ul";
      node.childrenUL.style.display = "none";
      node.li.appendChild(node.childrenUL);
    }
    return node.childrenUL;
  };

  return node;
}

function showRoot()
{
  var headerHeight = $("#top").height();
  var footerHeight = $("#nav-path").height();
  var windowHeight = $(window).height() - headerHeight - footerHeight;
  navtree.scrollTo('#selected',0,{offset:-windowHeight/2});
}

function expandNode(o, node, imm)
{
  if (node.childrenData && !node.expanded) 
  {
    if (!node.childrenVisited) 
    {
      getNode(o, node);
    }
    if (imm)
    {
      $(node.getChildrenUL()).show();
    } 
    else 
    {
      $(node.getChildrenUL()).slideDown("fast",showRoot);
    }
    if (node.isLast)
    {
      node.plus_img.src = node.relpath+"ftv2mlastnode.png";
    }
    else
    {
      node.plus_img.src = node.relpath+"ftv2mnode.png";
    }
    node.expanded = true;
  }
}

function getNode(o, po)
{
  po.childrenVisited = true;
  var l = po.childrenData.length-1;
  for (var i in po.childrenData) 
  {
    var nodeData = po.childrenData[i];
    po.children[i] = newNode(o, po, nodeData[0], nodeData[1], nodeData[2],
        i==l);
  }
}

function findNavTreePage(url, data)
{
  var nodes = data;
  var result = null;
  for (var i in nodes) 
  {
    var d = nodes[i];
    if (d[1] == url) 
    {
      return new Array(i);
    }
    else if (d[2] != null) // array of children
    {
      result = findNavTreePage(url, d[2]);
      if (result != null) 
      {
        return (new Array(i).concat(result));
      }
    }
  }
  return null;
}

function initNavTree(toroot,relpath)
{
  var o = new Object();
  o.toroot = toroot;
  o.node = new Object();
  o.node.li = document.getElementById("nav-tree-contents");
  o.node.childrenData = NAVTREE;
  o.node.children = new Array();
  o.node.childrenUL = document.createElement("ul");
  o.node.getChildrenUL = function() { return o.node.childrenUL; };
  o.node.li.appendChild(o.node.childrenUL);
  o.node.depth = 0;
  o.node.relpath = relpath;

  getNode(o, o.node);

  o.breadcrumbs = findNavTreePage(toroot, NAVTREE);
  if (o.breadcrumbs == null)
  {
    o.breadcrumbs = findNavTreePage("index.html",NAVTREE);
  }
  if (o.breadcrumbs != null && o.breadcrumbs.length>0)
  {
    var p = o.node;
    for (var i in o.breadcrumbs) 
    {
      var j = o.breadcrumbs[i];
      p = p.children[j];
      expandNode(o,p,true);
    }
    p.itemDiv.className = p.itemDiv.className + " selected";
    p.itemDiv.id = "selected";
    $(window).load(showRoot);
  }
}

