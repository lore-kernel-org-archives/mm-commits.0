From: akpm@osdl.org
Subject: - update-ext-mailing-list-address-fix.patch removed from -mm tree
Date: Wed, 06 Dec 2006 19:40:41 -0800
Message-ID: <200612070340.kB73efvv027639@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:43313 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968286AbWLGDkr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 22:40:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: erik@harddisk-recovery.nl, erik@harddisk-recovery.com, mm-commits@vger.kernel.org


The patch titled
     Update ext[23] mailing list address
has been removed from the -mm tree.  Its filename was
     update-ext-mailing-list-address-fix.patch

This patch was dropped because it was folded into update-ext-mailing-list-address.patch

------------------------------------------------------
Subject: Update ext[23] mailing list address
From: Erik Mouw <erik@harddisk-recovery.nl>

Add information about the ext4 filesystem to the MAINTAINERS file.

Signed-off-by: Erik Mouw <erik@harddisk-recovery.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+)

diff -puN MAINTAINERS~update-ext-mailing-list-address-fix MAINTAINERS
--- a/MAINTAINERS~update-ext-mailing-list-address-fix
+++ a/MAINTAINERS
@@ -1130,6 +1130,12 @@ M:	sct@redhat.com, akpm@osdl.org, adilge
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
 
+EXT4 FILE SYSTEM
+P:	Stephen Tweedie, Andrew Morton
+M:	sct@redhat.com, akpm@osdl.org, adilger@clusterfs.com
+L:	linux-ext4@vger.kernel.org
+S:	Maintained
+
 F71805F HARDWARE MONITORING DRIVER
 P:	Jean Delvare
 M:	khali@linux-fr.org
_

Patches currently in -mm which might be from erik@harddisk-recovery.nl are

update-ext-mailing-list-address.patch
update-ext-mailing-list-address-fix.patch

