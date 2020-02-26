import { library, dom } from "@fortawesome/fontawesome-svg-core";

// free solid
import {
  faBell ,
  faTrash,
  faTimes,
  faChevronCircleLeft,
  faExclamationCircle,
  faEdit,
} from "@fortawesome/free-solid-svg-icons";

// free regular
// import {
//   faFilePdf,
//   faCopy
// } from "@fortawesome/free-regular-svg-icons";

// free brands
// import {
//   faFacebook,
//   faTwitter,
//   faLinkedin,
//   faResearchgate,
//   faGoogle
// } from "@fortawesome/free-brands-svg-icons";

library.add(
  faBell,
  faTrash,
  faTimes,
  faChevronCircleLeft,
  faExclamationCircle,
  faEdit,
);

dom.watch();
