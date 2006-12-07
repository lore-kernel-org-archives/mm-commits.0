From: akpm@osdl.org
Subject: - io-storage-documentation-update-to-as-ioschedtxt.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:55 -0800
Message-ID: <200612072301.kB7N1tOF029820@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51720 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163799AbWLGXCl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:02:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: filipe@icewall.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     io/storage: Documentation update to as-iosched.txt
has been removed from the -mm tree.  Its filename was
     io-storage-documentation-update-to-as-ioschedtxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: io/storage: Documentation update to as-iosched.txt
From: Filipe <filipe@icewall.org>

Documentation update, adding references to CFQ scheduler and to another
document about selecting IO Schedulers.

Signed-off-by: Filipe Lautert <filipe@icewall.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/block/as-iosched.txt |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN Documentation/block/as-iosched.txt~io-storage-documentation-update-to-as-ioschedtxt Documentation/block/as-iosched.txt
--- a/Documentation/block/as-iosched.txt~io-storage-documentation-update-to-as-ioschedtxt
+++ a/Documentation/block/as-iosched.txt
@@ -24,8 +24,10 @@ very similar behavior to the deadline IO
 Selecting IO schedulers
 -----------------------
 To choose IO schedulers at boot time, use the argument 'elevator=deadline'.
-'noop' and 'as' (the default) are also available. IO schedulers are assigned
-globally at boot time only presently.
+'noop', 'as' and 'cfq' (the default) are also available. IO schedulers are
+assigned globally at boot time only presently. It's also possible to change
+the IO scheduler for a determined device on the fly, as described in
+Documentation/block/switching-sched.txt.
 
 
 Anticipatory IO scheduler Policies
_

Patches currently in -mm which might be from filipe@icewall.org are

origin.patch

