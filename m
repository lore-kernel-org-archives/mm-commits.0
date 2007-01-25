From: akpm@osdl.org
Subject: + netdev-add-a-maintainers-entry-for-via-velocity-and-update-my-address.patch added to -mm tree
Date: Thu, 25 Jan 2007 15:12:59 -0800
Message-ID: <200701252312.l0PNCxHW001325@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34722 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030490AbXAYXNO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 18:13:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: romieu@fr.zoreil.com, davem@davemloft.net, jeff@garzik.org


The patch titled
     netdev: add a MAINTAINERS entry for via-velocity and update my add=
ress
has been added to the -mm tree.  Its filename is
     netdev-add-a-maintainers-entry-for-via-velocity-and-update-my-addr=
ess.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: netdev: add a MAINTAINERS entry for via-velocity and update my=
 address
=46rom: Francois Romieu <romieu@fr.zoreil.com>

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 MAINTAINERS |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~netdev-add-a-maintainers-entry-for-via-velocity-a=
nd-update-my-address MAINTAINERS
--- a/MAINTAINERS~netdev-add-a-maintainers-entry-for-via-velocity-and-u=
pdate-my-address
+++ a/MAINTAINERS
@@ -1137,9 +1137,9 @@ T:	git kernel.org:/pub/scm/linux/kernel/
 S:	Maintained
=20
 DSCC4 DRIVER
-P:	Fran=E7ois Romieu
-M:	romieu@cogenit.fr
-M:	romieu@ensta.fr
+P:	Francois Romieu
+M:	romieu@fr.zoreil.com
+L:	netdev@vger.kernel.org
 S:	Maintained
=20
 DVB SUBSYSTEM AND DRIVERS
@@ -3574,6 +3574,12 @@ M:	khali@linux-fr.org
 L:	i2c@lm-sensors.org
 S:	Maintained
=20
+VIA VELOCITY NETWORK DRIVER
+P:	Francois Romieu
+M:	romieu@fr.zoreil.com
+L:	netdev@vger.kernel.org
+S:	Maintained
+
 UCLINUX (AND M68KNOMMU)
 P:	Greg Ungerer
 M:	gerg@uclinux.org
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

origin.patch
netdev-add-a-maintainers-entry-for-via-velocity-and-update-my-address.p=
atch
git-netdev-all.patch
r8169-warning-fixes.patch
