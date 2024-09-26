Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D41184544
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 21:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384660; cv=none; b=TxmXWF2frq98cLvOz69qz8TtPMtS7LdYvNezIa+10ibZJwiaHlxsQawOa9GpnXSy4xJWyW5biU5Hj85ZzP551RBEaGzqw61KgsGnfbBEi1D3PzEnlXXab0qkmJRSKfinI9yBI1ttGq/Lo65zHOQtI0yRgSuK1GVpM2WEXjPR6Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384660; c=relaxed/simple;
	bh=KVZCNQfw8W69pLGsNJmF6KOTbI8d0wQ0YVtq+tWcMRs=;
	h=Date:To:From:Subject:Message-Id; b=A9hKOJe7JoF97vODLe8K/wS5ENIpQy+u8A1Rzy8RNy0aOOeSBZuTgcp5XIBzqJHx27dprcAGrCC42qhgDkkuzwss/SIlkk9FkOXzPbj1cd2YQeYdrB7XutsdBb7EvhJ4hxX/h2HYtDo+XCFOl4959ZOEchNAMyqU0jkajUKFdJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1tuuc/90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1tuuc/90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F43EC4CECE;
	Thu, 26 Sep 2024 21:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727384660;
	bh=KVZCNQfw8W69pLGsNJmF6KOTbI8d0wQ0YVtq+tWcMRs=;
	h=Date:To:From:Subject:From;
	b=1tuuc/90qiizzKBJYewTI6RiQJ9yqmr5fUeuRvPyHKYxfS7oaI7pVIlens1HqlJcV
	 ArqepFptjMxGoNGrYcW5RImzd+L5ewmXcQ2+gTZ7OrkmjdaMkYsvaHbRCAWl/XXoji
	 ycnNNcxOa44KLzMP1EvG0gE6ZuGBfimpLNMhzEQI=
Date: Thu, 26 Sep 2024 14:04:19 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,didi.debian@cknow.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-kconfig-update-damon-doc-url.patch removed from -mm tree
Message-Id: <20240926210420.1F43EC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/Kconfig: update DAMON doc URL
has been removed from the -mm tree.  Its filename was
     mm-damon-kconfig-update-damon-doc-url.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Diederik de Haas <didi.debian@cknow.org>
Subject: mm/damon/Kconfig: update DAMON doc URL
Date: Tue, 24 Sep 2024 10:21:46 +0200

The old URL doesn't really work anymore and as the documentation has been
integrated in the main kernel documentation site, change the URL to point
to that.

Link: https://lkml.kernel.org/r/20240924082331.11499-1-didi.debian@cknow.org
Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/Kconfig~mm-damon-kconfig-update-damon-doc-url
+++ a/mm/damon/Kconfig
@@ -9,7 +9,7 @@ config DAMON
 	  access frequency of each memory region. The information can be useful
 	  for performance-centric DRAM level memory management.
 
-	  See https://damonitor.github.io/doc/html/latest-damon/index.html for
+	  See https://www.kernel.org/doc/html/latest/mm/damon/index.html for
 	  more information.
 
 config DAMON_KUNIT_TEST
_

Patches currently in -mm which might be from didi.debian@cknow.org are


