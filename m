From: akpm@linux-foundation.org
Subject: [merged] block-dont-select-percpu_rwsem.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:56:20 -0800
Message-ID: <20130225205620.9B62731C26E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:33259 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501Ab3BYU4V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:56:21 -0500
Received: by mail-qe0-f73.google.com with SMTP id 3so70949qea.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:56:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpatocka@redhat.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: block: don't select PERCPU_RWSEM
has been removed from the -mm tree.  Its filename was
     block-dont-select-percpu_rwsem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: block: don't select PERCPU_RWSEM

The block device doesn't use percpu rw-semaphore anymore, so don't select
it for compilation.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN block/Kconfig~block-dont-select-percpu_rwsem block/Kconfig
--- a/block/Kconfig~block-dont-select-percpu_rwsem
+++ a/block/Kconfig
@@ -4,7 +4,6 @@
 menuconfig BLOCK
        bool "Enable the block layer" if EXPERT
        default y
-       select PERCPU_RWSEM
        help
 	 Provide block layer support for the kernel.
 
_

Patches currently in -mm which might be from mpatocka@redhat.com are

linux-next.patch

