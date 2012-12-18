From: akpm@linux-foundation.org
Subject: [merged] aoe-update-internal-version-number-to-81.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:11:32 -0800
Message-ID: <20121218201132.9EC4B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:44096 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab2LRULd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:11:33 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so126337qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:11:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: update internal version number to 81
has been removed from the -mm tree.  Its filename was
     aoe-update-internal-version-number-to-81.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: update internal version number to 81

This version number is printed to the console on module initialization and
is available in sysfs, which is where the userland aoe-version tool looks
for it.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-update-internal-version-number-to-81 drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-update-internal-version-number-to-81
+++ a/drivers/block/aoe/aoe.h
@@ -1,6 +1,5 @@
