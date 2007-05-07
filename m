From: akpm@linux-foundation.org
Subject: - maintainer-change-for-connect-tech-inc.patch removed from -mm tree
Date: Sun, 06 May 2007 23:47:14 -0700
Message-ID: <200705070647.l476lEQl020379@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754069AbXEGGrW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 02:47:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stuartm@connecttech.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINER change for Connect Tech Inc
has been removed from the -mm tree.  Its filename was
     maintainer-change-for-connect-tech-inc.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: MAINTAINER change for Connect Tech Inc
=46rom: Stuart MacDonald <stuartm@connecttech.com>

I am no longer with CTI. The Support Department will handle all
inquiries regarding the WH.

Signed-off-by: Stuart MacDonald <stuartm@connecttech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/usb/usb-serial.txt |    2 +-
 MAINTAINERS                      |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/usb/usb-serial.txt~maintainer-change-for-connec=
t-tech-inc Documentation/usb/usb-serial.txt
--- a/Documentation/usb/usb-serial.txt~maintainer-change-for-connect-te=
ch-inc
+++ a/Documentation/usb/usb-serial.txt
@@ -42,7 +42,7 @@ ConnectTech WhiteHEAT 4 port converter
   http://www.connecttech.com
=20
   For any questions or problems with this driver, please contact
-  Stuart MacDonald at stuartm@connecttech.com
+  Connect Tech's Support Department at support@connecttech.com
=20
=20
 HandSpring Visor, Palm USB, and Cli=E9 USB driver
diff -puN MAINTAINERS~maintainer-change-for-connect-tech-inc MAINTAINER=
S
--- a/MAINTAINERS~maintainer-change-for-connect-tech-inc
+++ a/MAINTAINERS
@@ -3695,8 +3695,8 @@ W:	http://www.kroah.com/linux/
 S:	Maintained
=20
 USB SERIAL WHITEHEAT DRIVER
-P:	Stuart MacDonald
-M:	stuartm@connecttech.com
+P:	Support Department
+M:	support@connecttech.com
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 W:	http://www.connecttech.com
_

Patches currently in -mm which might be from stuartm@connecttech.com ar=
e

origin.patch
