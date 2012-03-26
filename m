From: akpm@linux-foundation.org
Subject: [merged] get_maintainer-use-a-default-unknown-s-status-role.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:36 -0700
Message-ID: <20120326192836.58255A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:38587 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2CZT2h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:28:37 -0400
Received: by yhgm50 with SMTP id m50so833790yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: use a default "unknown" S: status/role
has been removed from the -mm tree.  Its filename was
     get_maintainer-use-a-default-unknown-s-status-role.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: get_maintainer: use a default "unknown" S: status/role

When an "S:" status line is unavailable, use a default "unknown" role.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~get_maintainer-use-a-default-unknown-s-status-role scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-use-a-default-unknown-s-status-role
+++ a/scripts/get_maintainer.pl
@@ -931,7 +931,7 @@ sub get_maintainer_role {
     my $start = find_starting_index($index);
     my $end = find_ending_index($index);
 
-    my $role;
+    my $role = "unknown";
     my $subsystem = $typevalue[$start];
     if (length($subsystem) > 20) {
 	$subsystem = substr($subsystem, 0, 17);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-fix-remoteproc-f-typo.patch
checkpatch-suggest-pr_level-over-printkkern_level.patch

