Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245DB36606C
	for <mm-commits@vger.kernel.org>; Wed,  4 Mar 2026 18:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772647625; cv=none; b=SWFihcxQtOg0HNeoMG9uA+9MLt4pfOsa0nFfQpXW0sOY2DB4YERvJRqJV2jDHhU/Z7+WMiCu3B83bBhmhv415VqbE5/Ztd5xF+C2pCa/5Rv3sM+UcJp/JUCy+Ty+5cKwozb+gA7GDUpEghdCetfpS/VlD0Jy1g3DoMugZ4m+Fms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772647625; c=relaxed/simple;
	bh=5x4/g/11FNIeLyVOnwnD2VrBAneQ2B9g12poYXL/Ixg=;
	h=Date:To:From:Subject:Message-Id; b=refqflEUDl7GmBvGPQezgLDG4+E79xLjZtJejR8w6shL8njuUB3v+B1oiuV+yZi6+HI1AAbyCYRm/wbrxLGCCH0W4PvCfgfJhK8Pu44YZ5NY12DXBd7+GJtXgFcNjeNDOj3NSL+ngi9x19HBK33jC5gUdkdegiW0Y2IgOUipeNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QVc8YPbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QVc8YPbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8A6C4CEF7;
	Wed,  4 Mar 2026 18:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772647624;
	bh=5x4/g/11FNIeLyVOnwnD2VrBAneQ2B9g12poYXL/Ixg=;
	h=Date:To:From:Subject:From;
	b=QVc8YPbvAnfzbKiYwEnoALLaKWM8BZHEdx4WkkLuYmMmYkzi4mGGKMv2Xe6uGgsIE
	 uotZQFr9gH/0vxK+C1wTCXa3KxmJOYkXuEyPzuZya0JdLMysa4GRH8Owt1VF27qQGn
	 K6yG4Qrp6wnsawWcu6k0WIzQ+OxfJLyfoRy5OlR4=
Date: Wed, 04 Mar 2026 10:07:04 -0800
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-mailmap-update-email-address-for-lorenzo-stoakes.patch removed from -mm tree
Message-Id: <20260304180704.9C8A6C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS, mailmap: update email address for Lorenzo Stoakes
has been removed from the -mm tree.  Its filename was
     maintainers-mailmap-update-email-address-for-lorenzo-stoakes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: MAINTAINERS, mailmap: update email address for Lorenzo Stoakes
Date: Tue, 3 Mar 2026 19:50:25 +0000

I want to experiment with a new email setup, and using the @kernel.org
address is the easiest way to have flexibility on this.

Link: https://lkml.kernel.org/r/20260303195025.1170895-1-ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    3 ++-
 MAINTAINERS |   20 ++++++++++----------
 2 files changed, 12 insertions(+), 11 deletions(-)

--- a/.mailmap~maintainers-mailmap-update-email-address-for-lorenzo-stoakes
+++ a/.mailmap
@@ -491,7 +491,8 @@ Lior David <quic_liord@quicinc.com> <lio
 Loic Poulain <loic.poulain@oss.qualcomm.com> <loic.poulain@linaro.org>
 Loic Poulain <loic.poulain@oss.qualcomm.com> <loic.poulain@intel.com>
 Lorenzo Pieralisi <lpieralisi@kernel.org> <lorenzo.pieralisi@arm.com>
-Lorenzo Stoakes <lorenzo.stoakes@oracle.com> <lstoakes@gmail.com>
+Lorenzo Stoakes <ljs@kernel.org> <lstoakes@gmail.com>
+Lorenzo Stoakes <ljs@kernel.org> <lorenzo.stoakes@oracle.com>
 Luca Ceresoli <luca.ceresoli@bootlin.com> <luca@lucaceresoli.net>
 Luca Weiss <luca@lucaweiss.eu> <luca@z3ntu.xyz>
 Lucas De Marchi <demarchi@kernel.org> <lucas.demarchi@intel.com>
--- a/MAINTAINERS~maintainers-mailmap-update-email-address-for-lorenzo-stoakes
+++ a/MAINTAINERS
@@ -16654,7 +16654,7 @@ F:	mm/balloon.c
 MEMORY MANAGEMENT - CORE
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
-R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
@@ -16784,7 +16784,7 @@ F:	mm/workingset.c
 MEMORY MANAGEMENT - MISC
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
-R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
@@ -16875,7 +16875,7 @@ R:	David Hildenbrand <david@kernel.org>
 R:	Michal Hocko <mhocko@kernel.org>
 R:	Qi Zheng <zhengqi.arch@bytedance.com>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
-R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Lorenzo Stoakes <ljs@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/vmscan.c
@@ -16884,7 +16884,7 @@ F:	mm/workingset.c
 MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
-M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Rik van Riel <riel@surriel.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Vlastimil Babka <vbabka@kernel.org>
@@ -16929,7 +16929,7 @@ F:	mm/swapfile.c
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
-M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
@@ -16969,7 +16969,7 @@ F:	tools/testing/selftests/mm/uffd-*.[ch
 
 MEMORY MANAGEMENT - RUST
 M:	Alice Ryhl <aliceryhl@google.com>
-R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 L:	linux-mm@kvack.org
 L:	rust-for-linux@vger.kernel.org
@@ -16985,7 +16985,7 @@ F:	rust/kernel/page.rs
 MEMORY MAPPING
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
-M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Jann Horn <jannh@google.com>
 R:	Pedro Falcato <pfalcato@suse.de>
@@ -17015,7 +17015,7 @@ MEMORY MAPPING - LOCKING
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Suren Baghdasaryan <surenb@google.com>
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
-M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
 L:	linux-mm@kvack.org
@@ -17030,7 +17030,7 @@ F:	mm/mmap_lock.c
 MEMORY MAPPING - MADVISE (MEMORY ADVICE)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
-M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+M:	Lorenzo Stoakes <ljs@kernel.org>
 M:	David Hildenbrand <david@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Jann Horn <jannh@google.com>
@@ -23183,7 +23183,7 @@ K:	\b(?i:rust)\b
 
 RUST [ALLOC]
 M:	Danilo Krummrich <dakr@kernel.org>
-R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Uladzislau Rezki <urezki@gmail.com>
_

Patches currently in -mm which might be from ljs@kernel.org are


