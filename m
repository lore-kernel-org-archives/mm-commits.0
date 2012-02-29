From: akpm@linux-foundation.org
Subject: + get_maintainer-use-a-default-unknown-s-status-role.patch added to -mm tree
Date: Wed, 29 Feb 2012 12:26:23 -0800
Message-ID: <20120229202623.67F90A00AA@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:48992 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab2B2U0Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Feb 2012 15:26:25 -0500
Received: by wejx9 with SMTP id x9so127193wej.1
        for <mm-commits@vger.kernel.org>; Wed, 29 Feb 2012 12:26:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     Subject: get_maintainer: use a default "unknown" S: status/role
has been added to the -mm tree.  Its filename is
     get_maintainer-use-a-default-unknown-s-status-role.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: get_maintainer: use a default "unknown" S: status/role

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
thermal_sys-remove-unnecessary-line-continuations.patch
thermal_sys-remove-obfuscating-used-once-macros.patch
thermal_sys-kernel-style-cleanups.patch
thermal_sys-convert-printks-to-pr_level.patch
get_maintainer-use-a-default-unknown-s-status-role.patch
maintainers-fix-remoteproc-f-typo.patch
maintainers-update-mca-section.patch
maintainers-update-git-urls-for-26-deletions.patch
maintainers-add-status-to-alpha-architecture.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch
checkpatch-add-some-strict-coding-style-checks.patch
checkpatchpl-be-silent-when-q-and-ignore-is-given.patch

