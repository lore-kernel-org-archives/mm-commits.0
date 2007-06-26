From: akpm@linux-foundation.org
Subject: + knfsd-nfsd-remove-unused-header-interfaceh.patch added to -mm tree
Date: Mon, 25 Jun 2007 20:46:28 -0700
Message-ID: <200706260346.l5Q3kSwG017635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35765 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077AbXFZDqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 23:46:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd: remove unused header interface.h
has been added to the -mm tree.  Its filename is
     knfsd-nfsd-remove-unused-header-interfaceh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd: remove unused header interface.h
From: "J. Bruce Fields" <bfields@fieldses.org>

It looks like Al Viro gutted this header file five years ago and it hasn't
been touched since.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfsctl.c               |    1 -
 include/linux/nfsd/interface.h |   13 -------------
 include/linux/nfsd/nfsd.h      |    1 -
 3 files changed, 15 deletions(-)

diff -puN fs/nfsd/nfsctl.c~knfsd-nfsd-remove-unused-header-interfaceh fs/nfsd/nfsctl.c
--- a/fs/nfsd/nfsctl.c~knfsd-nfsd-remove-unused-header-interfaceh
+++ a/fs/nfsd/nfsctl.c
@@ -35,7 +35,6 @@
 #include <linux/nfsd/cache.h>
 #include <linux/nfsd/xdr.h>
 #include <linux/nfsd/syscall.h>
-#include <linux/nfsd/interface.h>
 
 #include <asm/uaccess.h>
 
diff -puN include/linux/nfsd/interface.h~knfsd-nfsd-remove-unused-header-interfaceh /dev/null
--- a/include/linux/nfsd/interface.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/*
- * include/linux/nfsd/interface.h
- *
- * defines interface between nfsd and other bits of
- * the kernel.  Particularly filesystems (eventually).
- *
- * Copyright (C) 2000 Neil Brown <neilb@cse.unsw.edu.au>
- */
-
-#ifndef LINUX_NFSD_INTERFACE_H
-#define LINUX_NFSD_INTERFACE_H
-
-#endif /* LINUX_NFSD_INTERFACE_H */
diff -puN include/linux/nfsd/nfsd.h~knfsd-nfsd-remove-unused-header-interfaceh include/linux/nfsd/nfsd.h
--- a/include/linux/nfsd/nfsd.h~knfsd-nfsd-remove-unused-header-interfaceh
+++ a/include/linux/nfsd/nfsd.h
@@ -22,7 +22,6 @@
 #include <linux/nfsd/export.h>
 #include <linux/nfsd/auth.h>
 #include <linux/nfsd/stats.h>
-#include <linux/nfsd/interface.h>
 /*
  * nfsd version
  */
_

Patches currently in -mm which might be from bfields@fieldses.org are

nfs-refactor-ip-address-sanity-checks-in-nfs-client.patch
knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion.patch
knfsd-nfsd4-silence-a-compiler-warning-in-acl-code.patch
knfsd-nfsd4-fix-handling-of-acl-errrors.patch
knfsd-nfsd-remove-unused-header-interfaceh.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix.patch
