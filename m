From: akpm@linux-foundation.org
Subject: - reiser4-configh.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:59:07 -0800
Message-ID: <200703060159.l261x79Q008567@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46502 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965089AbXCFB7J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:59:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.k.k.piotrowski@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kill #include "linux/config.h"
has been removed from the -mm tree.  Its filename was
     reiser4-configh.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: kill #include "linux/config.h"
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

config.h is obsolete. This patch removes all #include "linux/config.h".

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/plugin/compress/compress.c |    1 -
 fs/reiser4/reiser4.h                  |    1 -
 2 files changed, 2 deletions(-)

diff -puN fs/reiser4/plugin/compress/compress.c~reiser4-configh fs/reiser4/plugin/compress/compress.c
--- a/fs/reiser4/plugin/compress/compress.c~reiser4-configh
+++ a/fs/reiser4/plugin/compress/compress.c
@@ -6,7 +6,6 @@
 #include "../plugin.h"
 #include "minilzo.h"
 
-#include <linux/config.h>
 #include <linux/zlib.h>
 #include <linux/types.h>
 #include <linux/hardirq.h>
diff -puN fs/reiser4/reiser4.h~reiser4-configh fs/reiser4/reiser4.h
--- a/fs/reiser4/reiser4.h~reiser4-configh
+++ a/fs/reiser4/reiser4.h
@@ -6,7 +6,6 @@
 #if !defined( __REISER4_H__ )
 #define __REISER4_H__
 
-#include <linux/config.h>
 #include <asm/param.h>		/* for HZ */
 #include <linux/errno.h>
 #include <linux/types.h>
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

origin.patch
git-ia64.patch
git-input.patch
i386-irq-kill-irq-compression-fix.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
reiser4.patch
reiser4-configh.patch
