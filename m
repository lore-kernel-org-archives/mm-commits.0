From: akpm@linux-foundation.org
Subject: [merged] checkpatch-version-027.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:17:18 -0800
Message-ID: <200901161917.n0GJHIfT025888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936527AbZAPTRi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:17:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: version: 0.27
has been removed from the -mm tree.  Its filename was
     checkpatch-version-027.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: version: 0.27
From: Andy Whitcroft <apw@canonical.com>

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-version-027 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-version-027
+++ a/scripts/checkpatch.pl
@@ -10,7 +10,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.26';
+my $V = '0.27';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
mmc-add-modalias-linkage-for-mmc-sd-devices.patch

