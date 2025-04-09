Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9301A13B280
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 01:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744163151; cv=none; b=p0QqbSGah54+YbFCXqGnXHkwZRTamliNd1BlW2TPtG5ZvgTPpj4VmdLfIkKhCc0AW2fH5PZjRRQNUwRMf4818QDAqW6RngHKjCKA6ht65KKWgygwQXm2Mka01mx7RkrFis8/eSXBrqw1DhBLqTMTSmh2i4dmI1PeFLqUH9pQ59A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744163151; c=relaxed/simple;
	bh=tzjlGvGzDND4RiUejyUCmQrsHHMkVDH1YjD9hBRum0g=;
	h=Date:To:From:Subject:Message-Id; b=cHBBblP/I5UMuMjtl3N/it4n1qY5dDZ7mMKBei7yZKZpsmwIs8OTIQqKr5ML6zqUQxr59w8p6gIwvWE7KW/7drG4j/HczBxYQiaMtr/73N5nr2MD12EbKV21TTqGT4JxR2psnOHKwaP+iySYzuAP50s57IuU84SD9Qt6QUkFmVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mPDY42y5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mPDY42y5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A3AC4CEE5;
	Wed,  9 Apr 2025 01:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744163151;
	bh=tzjlGvGzDND4RiUejyUCmQrsHHMkVDH1YjD9hBRum0g=;
	h=Date:To:From:Subject:From;
	b=mPDY42y5iHXHyafekNxfjnx15XsoLsUfDx1elwMUVbJMPVDWu492uf+ifMmhEjrq/
	 vNx/6bvgRK0xoVNsJMQpWQLtGKsRJ9WkKaf9AkwE0TDLD1O6Tnn9Q96PgGwmzaZyDQ
	 YQEWDb9NqBOPRC5i8b2urbyH25/8xiwJqf1vOIDE=
Date: Tue, 08 Apr 2025 18:45:50 -0700
To: mm-commits@vger.kernel.org,rakie.kim@sk.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-support-memory-hotplug-in-weighted-interleave-checkpatch-fixes.patch added to mm-new branch
Message-Id: <20250409014550.E5A3AC4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-mempolicy-support-memory-hotplug-in-weighted-interleave-checkpatch-fixes
has been added to the -mm mm-new branch.  Its filename is
     mm-mempolicy-support-memory-hotplug-in-weighted-interleave-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-support-memory-hotplug-in-weighted-interleave-checkpatch-fixes.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mempolicy-support-memory-hotplug-in-weighted-interleave-checkpatch-fixes
Date: Tue Apr  8 06:45:24 PM PDT 2025

ERROR: space required before the open parenthesis '('
#178: FILE: mm/mempolicy.c:3570:
+	switch(action) {

total: 1 errors, 0 warnings, 163 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-mempolicy-support-memory-hotplug-in-weighted-interleave.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-support-memory-hotplug-in-weighted-interleave-checkpatch-fixes
+++ a/mm/mempolicy.c
@@ -3567,7 +3567,7 @@ static int wi_node_notifier(struct notif
 	if (nid < 0)
 		return NOTIFY_OK;
 
-	switch(action) {
+	switch (action) {
 	case MEM_ONLINE:
 		err = sysfs_wi_node_add(nid);
 		if (err)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

radix-tree-add-missing-cleanuph-fix.patch
samples-livepatch-add-module-descriptions-fix.patch
mm-kasan-add-module-decription-fix.patch
mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
mm-mempolicy-support-memory-hotplug-in-weighted-interleave-checkpatch-fixes.patch

