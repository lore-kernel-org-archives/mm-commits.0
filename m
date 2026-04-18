Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5B437104D
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499192; cv=none; b=m+c3EtlEdVNV2u4TFZs3xs9whd1KlQ5YLl2cMyk/WdH3rMh3b1TFg/zXl2S41ejb5JZPNtA8qQU3JRFCdQ6bEbq2GzsCkwm2ppCCRmQMESnNl05a6Gjvsur/NQDQ86xVYb/aJ8bdJuKUr84yFQ62VHshDW2v5HZoNNdTRdI8Tno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499192; c=relaxed/simple;
	bh=o7O0MK+WmUJkBY7wiVBD0OqXojLz6kLBJpyYvL895F4=;
	h=Date:To:From:Subject:Message-Id; b=dXXwOAfpmgZzsie00s3WYMI0jcgEWr5amsC9XFRB2VqcZIO5xSP/CB+7IeuxMafy79ZisfAOBvIb1ld35mdHyv6AoPLLOB6/x9bxgJEQHXD1Bk0tGyJ/X7WMxmmjjcEVeA5bi6biEI+vACESHOWw+BI0dsTpbPVPtKwrz+NiOUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=trWAy5+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="trWAy5+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBFCC19424;
	Sat, 18 Apr 2026 07:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499192;
	bh=o7O0MK+WmUJkBY7wiVBD0OqXojLz6kLBJpyYvL895F4=;
	h=Date:To:From:Subject:From;
	b=trWAy5+0LzcQ4tv0GgK7QFRP+eiXWVCt88QhdJci4PDVl+D0rZ9KoSVGhXTKHQ8CH
	 Edmne7c9Z0h07kgiMrDbf7I6WksBZeA8QYi68dS5aElpRoCfe0R+UA42j/mJQVZcRw
	 uhrCja3ys/SQsD6d9A5uW1nm194+N2zpCXKWBHhE=
Date: Sat, 18 Apr 2026 00:59:47 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,david@kernel.org,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-drop-include-linux-liveupdate-from-live-update.patch removed from -mm tree
Message-Id: <20260418075951.AEBFCC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: drop include/linux/liveupdate from LIVE UPDATE
has been removed from the -mm tree.  Its filename was
     maintainers-drop-include-linux-liveupdate-from-live-update.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: MAINTAINERS: drop include/linux/liveupdate from LIVE UPDATE
Date: Tue, 14 Apr 2026 12:17:20 +0000

The directory does not exist any more.

Link: https://lore.kernel.org/20260414121752.1912847-4-pratyush@kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-drop-include-linux-liveupdate-from-live-update
+++ a/MAINTAINERS
@@ -14816,7 +14816,6 @@ F:	Documentation/mm/memfd_preservation.r
 F:	Documentation/userspace-api/liveupdate.rst
 F:	include/linux/kho/abi/
 F:	include/linux/liveupdate.h
-F:	include/linux/liveupdate/
 F:	include/uapi/linux/liveupdate.h
 F:	kernel/liveupdate/
 F:	lib/tests/liveupdate.c
_

Patches currently in -mm which might be from pratyush@kernel.org are


