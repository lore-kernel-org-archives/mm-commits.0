From: akpm@linux-foundation.org
Subject: - usb-storage-onetouchc-make-a-function-static.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:52:01 -0700
Message-ID: <200804300552.m3U5q1xm030265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757734AbYD3Fwp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:52:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     usb/storage/onetouch.c: make a function static
has been removed from the -mm tree.  Its filename was
     usb-storage-onetouchc-make-a-function-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb/storage/onetouch.c: make a function static
From: Adrian Bunk <bunk@kernel.org>

Make the needlessly global onetouch_release_input() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/onetouch.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/usb/storage/onetouch.c~usb-storage-onetouchc-make-a-function-static drivers/usb/storage/onetouch.c
--- a/drivers/usb/storage/onetouch.c~usb-storage-onetouchc-make-a-function-static
+++ a/drivers/usb/storage/onetouch.c
@@ -38,7 +38,7 @@
 #include "onetouch.h"
 #include "debug.h"
 
-void onetouch_release_input(void *onetouch_);
+static void onetouch_release_input(void *onetouch_);
 
 struct usb_onetouch {
 	char name[128];
@@ -223,7 +223,7 @@ int onetouch_connect_input(struct us_dat
 	return error;
 }
 
-void onetouch_release_input(void *onetouch_)
+static void onetouch_release_input(void *onetouch_)
 {
 	struct usb_onetouch *onetouch = (struct usb_onetouch *) onetouch_;
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
mm-filemapc-generic_write_checks-mustnt-be-inline.patch
fs-block_devc-i_bdev-mustnt-be-inline.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
reiserfs-some-functions-mustnt-be-inline.patch
git-acpi.patch
git-x86.patch
arch-x86-video-fbdevc-add-module_license.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-m32r.patch
net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch
nfs-make-nfs4_drop_state_owner-static.patch
git-ocfs2.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
make-marker_debug-static.patch
reiser4.patch

