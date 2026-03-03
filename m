Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C999361653
	for <mm-commits@vger.kernel.org>; Tue,  3 Mar 2026 22:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772576373; cv=none; b=t7k6B0qlEZRvjuoGtkADOjvnptWDQa7P7yAjIH+YZ2URVdBeDLtbnpPXBcMw84/YfetMH5OaAATdLRcHuwxah/A3JUoDCh9ms7+2dasFT2ezmqLgM0cW6x5Pr0DXAgDCQy9zyEPAj+jJzsmISdsCeUmWkwBCr4vHb8ycRpOCw2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772576373; c=relaxed/simple;
	bh=tknXl3SEcav5eNU0pZAnMPzJ6I0FOVnlAyMCtW3Vo4U=;
	h=Date:To:From:Subject:Message-Id; b=bQHF9QREPnJrWPhUeA/FlYAVV+PmE0WV3YUhI7OWduPIEeQ2XxtWpG5gF1F6NnTM+PJwZWmGFsNlVhR+lAyHw5goVIgSX8PdZVNZYROZ/AxGpdXKA3ppQxTtua+kV6aoGxNJjwL7XWaDUBEtCy6o/jZPpt/uX3Q2/JrEEj3eEdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jkCtos7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jkCtos7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160D9C116C6;
	Tue,  3 Mar 2026 22:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772576373;
	bh=tknXl3SEcav5eNU0pZAnMPzJ6I0FOVnlAyMCtW3Vo4U=;
	h=Date:To:From:Subject:From;
	b=jkCtos7tiGknphhBHDY4mMcvd3LtrgyKL4PSxF8+tXq9HkYIfMdvz71I9CtBAkHE7
	 xaMGlYyLOdUayNUKwdLXSRLYOwuTY58NyafATrpM6ySTYxlq+DbtR6k5AIbfmt5eRX
	 zqqPaLPUVpqIHbP9ln+ENuLMZz0XJIK/Y/hgfYxE=
Date: Tue, 03 Mar 2026 14:19:32 -0800
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-mailmap-update-email-address-for-lorenzo-stoakes.patch added to mm-hotfixes-unstable branch
Message-Id: <20260303221933.160D9C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS, mailmap: update email address for Lorenzo Stoakes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-mailmap-update-email-address-for-lorenzo-stoakes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-mailmap-update-email-address-for-lorenzo-stoakes.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

maintainers-mailmap-update-email-address-for-lorenzo-stoakes.patch

