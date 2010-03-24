From: akpm@linux-foundation.org
Subject: [alternative-merged] headerdep-perlcritic-warning.patch removed from -mm tree
Date: Wed, 24 Mar 2010 10:50:51 -0400
Message-ID: <201003241751.o2OHpk2C015480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752784Ab0CXRwb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Mar 2010 13:52:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@vyatta.com, amwang@redhat.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     headerdep: perlcritic warning
has been removed from the -mm tree.  Its filename was
     headerdep-perlcritic-warning.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: headerdep: perlcritic warning
From: Stephen Hemminger <shemminger@vyatta.com>

Minor perlcritic warning:
headerdep.pl: "return" statement with explicit "undef" at line 84, column 2.  See page 199 of PBP.  (Severity: 5)

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Acked-by: WANG Cong <amwang@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/headerdep.pl |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN scripts/headerdep.pl~headerdep-perlcritic-warning scripts/headerdep.pl
--- a/scripts/headerdep.pl~headerdep-perlcritic-warning
+++ a/scripts/headerdep.pl
@@ -80,8 +80,7 @@ sub search {
 		my $path = "$i/$filename";
 		return $path if -f $path;
 	}
