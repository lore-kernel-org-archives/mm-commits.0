From: akpm@linux-foundation.org
Subject: - add-documentation-w1w1-masters-00-index.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:42 -0700
Message-ID: <200710180704.l9I74ge1031581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36914 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760437AbXJRHSP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:18:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     Add Documentation/{w1,w1/masters}/00-INDEX
has been removed from the -mm tree.  Its filename was
     add-documentation-w1w1-masters-00-index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add Documentation/{w1,w1/masters}/00-INDEX
From: Rob Landley <rob@landley.net>

Two 00-INDEX files under Documentation/w1

Signed-off-by: Rob Landley <rob@landley.net>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/w1/00-INDEX         |    8 ++++++++
 Documentation/w1/masters/00-INDEX |    6 ++++++
 Documentation/w1/masters/ds2482   |    2 +-
 Documentation/w1/masters/ds2490   |    2 +-
 4 files changed, 16 insertions(+), 2 deletions(-)

diff -puN /dev/null Documentation/w1/00-INDEX
--- /dev/null
+++ a/Documentation/w1/00-INDEX
@@ -0,0 +1,8 @@
+00-INDEX
+	- This file
+masters/
+	- Individual chips providing 1-wire busses.
+w1.generic
+	- The 1-wire (w1) bus
+w1.netlink
+	- Userspace communication protocol over connector [1].
diff -puN /dev/null Documentation/w1/masters/00-INDEX
--- /dev/null
+++ a/Documentation/w1/masters/00-INDEX
@@ -0,0 +1,6 @@
+00-INDEX
+	- This file
+ds2482
+	- The Maxim/Dallas Semiconductor DS2482 provides 1-wire busses.
+ds2490
+	- The Maxim/Dallas Semiconductor DS2490 builds USB <-> W1 bridges.
diff -puN Documentation/w1/masters/ds2482~add-documentation-w1w1-masters-00-index Documentation/w1/masters/ds2482
--- a/Documentation/w1/masters/ds2482~add-documentation-w1w1-masters-00-index
+++ a/Documentation/w1/masters/ds2482
@@ -15,7 +15,7 @@ Author: Ben Gardner <bgardner@wabtec.com
 Description
 -----------
 
-The Maixm/Dallas Semiconductor DS2482 is a I2C device that provides
+The Maxim/Dallas Semiconductor DS2482 is a I2C device that provides
 one (DS2482-100) or eight (DS2482-800) 1-wire busses.
 
 
diff -puN Documentation/w1/masters/ds2490~add-documentation-w1w1-masters-00-index Documentation/w1/masters/ds2490
--- a/Documentation/w1/masters/ds2490~add-documentation-w1w1-masters-00-index
+++ a/Documentation/w1/masters/ds2490
@@ -10,7 +10,7 @@ Author: Evgeniy Polyakov <johnpol@2ka.mi
 Description
 -----------
 
-The Maixm/Dallas Semiconductor DS2490 is a chip
+The Maxim/Dallas Semiconductor DS2490 is a chip
 which allows to build USB <-> W1 bridges.
 
 DS9490(R) is a USB <-> W1 bus master device
_

Patches currently in -mm which might be from rob@landley.net are

origin.patch
comment-typo-in-scripts-kconfig-makefile.patch
