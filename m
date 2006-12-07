From: akpm@osdl.org
Subject: - kernel-api-book-remove-videodev-chapter.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:06:48 -0800
Message-ID: <200612072306.kB7N6m3f030305@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52722 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163926AbWLGXHI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:07:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-api book: remove videodev chapter
has been removed from the -mm tree.  Its filename was
     kernel-api-book-remove-videodev-chapter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel-api book: remove videodev chapter
From: Randy Dunlap <randy.dunlap@oracle.com>

Remove the videodev chapter from the kernel-api book.  It's done much better
in the videobook kernel-doc.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/DocBook/kernel-api.tmpl |    5 -----
 1 file changed, 5 deletions(-)

diff -puN Documentation/DocBook/kernel-api.tmpl~kernel-api-book-remove-videodev-chapter Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~kernel-api-book-remove-videodev-chapter
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -418,11 +418,6 @@ X!Edrivers/pnp/system.c
 !Idrivers/parport/daisy.c
   </chapter>
 
-  <chapter id="viddev">
-     <title>Video4Linux</title>
-!Edrivers/media/video/videodev.c
-  </chapter>
-
   <chapter id="message_devices">
 	<title>Message-based devices</title>
      <sect1><title>Fusion message devices</title>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-ieee1394.patch
git-input.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
generic-bug-implementation-handle-bug=n.patch
reiser4-use-null-for-pointers.patch
visws-sgivwfb-is-module-needs-exports.patch
linux-fbdev-devel-is-subscribers-only.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch

