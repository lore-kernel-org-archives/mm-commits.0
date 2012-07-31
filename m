From: akpm@linux-foundation.org
Subject: [merged] checkpatch-update-alignment-check.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:51:34 -0700
Message-ID: <20120731185134.C480C10007F@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756337Ab2GaSvg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:51:36 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:51:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: Update alignment check
has been removed from the -mm tree.  Its filename was
     checkpatch-update-alignment-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: Update alignment check

Parenthesis alignment doesn't correctly check an existing line after an
inserted or modified line with an open parenthesis.

Fix it.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-update-alignment-check scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-update-alignment-check
+++ a/scripts/checkpatch.pl
@@ -1848,8 +1848,8 @@ sub process {
 
 			my $pos = pos_last_openparen($rest);
 			if ($pos >= 0) {
-				$line =~ /^\+([ \t]*)/;
-				my $newindent = $1;
+				$line =~ /^(\+| )([ \t]*)/;
+				my $newindent = $2;
 
 				my $goodtabindent = $oldindent .
 					"\t" x ($pos / 8) .
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2.patch
linux-next.patch
thermal-add-renesas-r-car-thermal-sensor-support.patch

