From: akpm@linux-foundation.org
Subject: - diskquota-32bit-quota-tools-on-64bit-architectures-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:59:44 -0700
Message-ID: <200707092159.l69Lxi72014841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57402 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755976AbXGIWAW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 18:00:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.k.k.piotrowski@gmail.com, ak@suse.de, jack@ucw.cz, tony.luck@intel.com, vtaras@openvz.org, mm-commits@vger.kernel.org


The patch titled
     fs/quota.c build fix
has been removed from the -mm tree.  Its filename was
     diskquota-32bit-quota-tools-on-64bit-architectures-fix.patch

This patch was dropped because it was folded into diskquota-32bit-quota-tools-on-64bit-architectures.patch

------------------------------------------------------
Subject: fs/quota.c build fix
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

  CC      fs/quota.o
fs/quota.c:13:24: error: asm/compat.h: No such file or directory
make[1]: *** [fs/quota.o] Error 1
make: *** [fs] Error 2

diskquota-32bit-quota-tools-on-64bit-architectures.patch

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Vasily Tarasov <vtaras@openvz.org>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/quota.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/quota.c~diskquota-32bit-quota-tools-on-64bit-architectures-fix fs/quota.c
--- a/fs/quota.c~diskquota-32bit-quota-tools-on-64bit-architectures-fix
+++ a/fs/quota.c
@@ -10,7 +10,7 @@
 #include <linux/slab.h>
 #include <asm/current.h>
 #include <asm/uaccess.h>
-#include <asm/compat.h>
+#include <linux/compat.h>
 #include <linux/kernel.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

git-kvm.patch
diskquota-32bit-quota-tools-on-64bit-architectures.patch
diskquota-32bit-quota-tools-on-64bit-architectures-fix.patch
diskquota-32bit-quota-tools-on-64bit-architectures-fix-fix.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
reiser4.patch
