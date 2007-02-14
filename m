From: akpm@linux-foundation.org
Subject: + update-osdl-linux-foundation-maintainer-addresses.patch added to -mm tree
Date: Wed, 14 Feb 2007 15:09:08 -0800
Message-ID: <200702142309.l1EN98Z8012267@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50396 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964810AbXBNXJO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 18:09:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: horms@verge.net.au


The patch titled
     Update OSDL/Linux-Foundation maintainer addresses
has been added to the -mm tree.  Its filename is
     update-osdl-linux-foundation-maintainer-addresses.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Update OSDL/Linux-Foundation maintainer addresses
From: Simon Horman <horms@verge.net.au>

The patch below updates MAINTAIER address
  Individuals (Only Andrew :): osdl.org -> linux-foundation.org
  Lists:                       osdl.org -> lists.osdl.org

I assume the latter will change at some stage, but at least
with this change the osdl/linux-foundation lists are consistent.

Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff -puN MAINTAINERS~update-osdl-linux-foundation-maintainer-addresses MAINTAINERS
--- a/MAINTAINERS~update-osdl-linux-foundation-maintainer-addresses
+++ a/MAINTAINERS
@@ -1350,7 +1350,7 @@ S:	Maintained
 ETHERNET BRIDGE
 P:	Stephen Hemminger
 M:	shemminger@linux-foundation.org
-L:	bridge@osdl.org
+L:	bridge@lists.osdl.org
 W:	http://bridge.sourceforge.net/
 S:	Maintained
 
@@ -1365,13 +1365,13 @@ S:	Maintained
 
 EXT3 FILE SYSTEM
 P:	Stephen Tweedie, Andrew Morton
-M:	sct@redhat.com, akpm@osdl.org, adilger@clusterfs.com
+M:	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
 
 EXT4 FILE SYSTEM
 P:	Stephen Tweedie, Andrew Morton
-M:	sct@redhat.com, akpm@osdl.org, adilger@clusterfs.com
+M:	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
 
@@ -1974,7 +1974,7 @@ S:	Supported
 
 JOURNALLING LAYER FOR BLOCK DEVICES (JBD)
 P:	Stephen Tweedie, Andrew Morton
-M:	sct@redhat.com, akpm@osdl.org
+M:	sct@redhat.com, akpm@linux-foundation.org
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
 
@@ -2045,7 +2045,7 @@ P:	Eric Biederman
 M:	ebiederm@xmission.com
 W:	http://www.xmission.com/~ebiederm/files/kexec/
 L:	linux-kernel@vger.kernel.org
-L:	fastboot@osdl.org
+L:	fastboot@lists.osdl.org
 S:	Maintained
 
 KPROBES
@@ -2383,7 +2383,7 @@ S:	Maintained
 NETEM NETWORK EMULATOR
 P:	Stephen Hemminger
 M:	shemminger@linux-foundation.org
-L:	netem@osdl.org
+L:	netem@lists.osdl.org
 S:	Maintained
 
 NETFILTER/IPTABLES/IPCHAINS
@@ -2422,7 +2422,7 @@ S:	Maintained
 
 NETWORK DEVICE DRIVERS
 P:	Andrew Morton
-M:	akpm@osdl.org
+M:	akpm@linux-foundation.org
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
 L:	netdev@vger.kernel.org
@@ -3117,7 +3117,7 @@ S:	Supported
 SOFTWARE SUSPEND:
 P:	Pavel Machek
 M:	pavel@suse.cz
-L:	linux-pm@osdl.org
+L:	linux-pm@lists.osdl.org
 S:	Maintained
 
 SONIC NETWORK DRIVER
_

Patches currently in -mm which might be from horms@verge.net.au are

origin.patch
git-ia64.patch
ia64-point-saved_max_pfn-to-the-max_pfn-of-the-entire-system.patch
update-osdl-linux-foundation-maintainer-addresses.patch
