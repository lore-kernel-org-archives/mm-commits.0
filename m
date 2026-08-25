Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6D434E777
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622913; cv=none; b=FQIxyV5WdTFS1OsSprLt+sK2a2xhhKt4ZvTZS2+/SPALwpuQuT6anAepyDC5QLVk35G4FojYCR2E1ZBBERANt3hia9A13ZU0BIj0aNdcTIY5BPD+T2MDQo3EDUaS1k76I12ZKRiIQW0ENY3OgkRQMJH0GQG5WPYif2MXVmziknc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622913; c=relaxed/simple;
	bh=sgFbJrrvu38eDDR/8WyF1t6k4PsGiHq7MLXYBShybe0=;
	h=Date:To:From:Subject:Message-Id; b=OxdNKlEHpLa5WEqZ1FHbS5AdnGeIepesn6bQPPu7wuO1AiBJrg8yHvd3ChLbAw0AhV+tVK9UyYaHg4bZNHHkX3v1IWanv4H7JXg9R9twz0r1RJqeELvOdA94FlcgBOM01H5UJYLsdDc96GHoLyMdSaJknfAUD77FsnFFy8IPYtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M9NqhGf3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M9NqhGf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09C71F000E9;
	Tue, 25 Aug 2026 01:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622911;
	bh=iRdA1MxPi2ZiouR04zrIFpUpfqvKt9pmc1zWgPu8yJs=;
	h=Date:To:From:Subject;
	b=M9NqhGf3OxALqqi5tnm13EcszMVyc2EKNERndnPW9HQmw10hg3KFkLPcBgZkbYetG
	 vD1eQMeA1SAaHfL5tlvvcj3A9uyS7/vwNpwflQmZzeQFQN4humYc/Ut/kS/VLvTdDX
	 BrVsIPFLJhJJ7MYEPk1PNfCPhU8CGiaw8BVTWR94=
Date: Mon, 24 Aug 2026 18:55:11 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,andrewjballance@gmail.com,aliceryhl@google.com,akpm@linux-foundation.org,sercombe.joel.mark@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-fix-comment-typo.patch removed from -mm tree
Message-Id: <20260825015511.C09C71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: fix comment typo
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-comment-typo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Sercombe <sercombe.joel.mark@gmail.com>
Subject: maple_tree: fix comment typo
Date: Thu, 13 Aug 2026 20:38:47 +0200

Fix a spelling mistake n a code comment.  This is a comment only change
with no functional impact.

Link: https://lore.kernel.org/20260813183847.474357-1-sercombe.joel.mark@gmail.com
Signed-off-by: Mark Sercombe <sercombe.joel.mark@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-fix-comment-typo
+++ a/lib/maple_tree.c
@@ -3590,7 +3590,7 @@ set_content:
 
 /**
  * mas_prealloc_calc() - Calculate number of nodes needed for a
- * given store oepration
+ * given store operation
  * @wr_mas: The maple write state
  * @entry: The entry to store into the tree
  *
_

Patches currently in -mm which might be from sercombe.joel.mark@gmail.com are


