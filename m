From: akpm@linux-foundation.org
Subject: [merged] checkpatch-version-028.patch removed from -mm tree
Date: Mon, 02 Mar 2009 11:23:25 -0800
Message-ID: <200903021923.n22JNP1Y014407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528AbZCBTX7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 14:23:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: version 0.28
has been removed from the -mm tree.  Its filename was
     checkpatch-version-028.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: version 0.28
From: Andy Whitcroft <apw@canonical.com>

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-version-028 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-version-028
+++ a/scripts/checkpatch.pl
@@ -10,7 +10,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.27';
+my $V = '0.28';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
linux-next.patch
mmc-add-modalias-linkage-for-mmc-sd-devices.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume-fix.patch

