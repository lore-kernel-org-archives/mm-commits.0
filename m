From: akpm@linux-foundation.org
Subject: + mpt-remove-unused-struct-mpt_proc_entry_t.patch added to -mm tree
Date: Mon, 14 Apr 2008 23:25:28 -0700
Message-ID: <200804150625.m3F6PSPe014560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342AbYDOGZu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 02:25:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, Eric.Moore@lsi.com, James.Bottomley@HansenPartnership.com


The patch titled
     MPT: remove unused struct -- mpt_proc_entry_t
has been added to the -mm tree.  Its filename is
     mpt-remove-unused-struct-mpt_proc_entry_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MPT: remove unused struct -- mpt_proc_entry_t
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.h |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN drivers/message/fusion/mptbase.h~mpt-remove-unused-struct-mpt_proc_entry_t drivers/message/fusion/mptbase.h
--- a/drivers/message/fusion/mptbase.h~mpt-remove-unused-struct-mpt_proc_entry_t
+++ a/drivers/message/fusion/mptbase.h
@@ -400,17 +400,6 @@ typedef struct _VirtDevice {
 #define MPT_TARGET_FLAGS_RAID_COMPONENT	0x40
 #define MPT_TARGET_FLAGS_LED_ON		0x80
 
-/*
- *	/proc/mpt interface
- */
-typedef struct {
-	const char	*name;
-	mode_t		 mode;
-	int		 pad;
-	read_proc_t	*read_proc;
-	write_proc_t	*write_proc;
-} mpt_proc_entry_t;
-
 #define MPT_PROC_READ_RETURN(buf,start,offset,request,eof,len) \
 do { \
 	len -= offset;			\
_

Patches currently in -mm which might be from adobriyan@gmail.com are

fbdev-fix-proc-fb-oops-after-module-removal.patch
v4l-fix-concurrent-read-from-proc-videocodecs.patch
tags-add-menuconfig-symbols-as-well.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
remove-the-macro-get_personality.patch
nv-drop-useless-module-ifdefs.patch
nv-drop-useless-config_pci-checks.patch
nv-fix-sparse-noise.patch
procfs-mem-permission-cleanup.patch
proc-simplify-locking-in-remove_proc_entry.patch
proc-less-special-case-in-xlate-code.patch
proc-drop-several-pde-valid-invalid-checks.patch
proc-remove-proc_bus.patch
proc-remove-proc_root_fs.patch
proc-remove-proc_root_driver.patch
proc-remove-proc_root-from-drivers.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

