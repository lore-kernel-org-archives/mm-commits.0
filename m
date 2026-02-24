Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DCC2FFF8F
	for <mm-commits@vger.kernel.org>; Tue, 24 Feb 2026 19:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771960443; cv=none; b=NxBMqYhalkcAcN0NrjsGWNEvbkBPH2YE8Z7MiN1HASuTbJ27+VbVCI4x4bKyAcmpe0sbMUYiwszpxdjSRJ27BVjr5ldS9X1Vub/7gSuK2qoH1izVlQ6o++1t1ZvxHApYRFQ+vWKBBpagZ4QFsassjjsJgvFTxK/ZtmGcMcX6jrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771960443; c=relaxed/simple;
	bh=FqSWMCfvqXoFtVAxwxtTOqlk8FoWk+v2IcnILyyGZhg=;
	h=Date:To:From:Subject:Message-Id; b=G2SOOV6hQ74Mbp3caCJYEiWUVraYKzzfjWbl9M40FnJ73Czjg+UVQaAJLz4dh+TQOqbkP6VPihSDbjWNP56hEzs8yrQ1yIowughIqCDLD8eJ13X5hoWP4UPRf6kAWQS8N0mITIlZWa5XnkBVERiszab3j7LVdiacmnStzmDW/oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XnL+kniQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XnL+kniQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97487C116D0;
	Tue, 24 Feb 2026 19:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771960443;
	bh=FqSWMCfvqXoFtVAxwxtTOqlk8FoWk+v2IcnILyyGZhg=;
	h=Date:To:From:Subject:From;
	b=XnL+kniQmCRnf8O/twsCGL2XoxnncYrrwrEpet+E6Ky8P7bk71igsfzuzp0nedqYr
	 7zz9XlDjsGN6drghcGaw0BGbOA8mynF2FBJKzR6nVSWucHKldJe95NJLR36/2i4384
	 oXfy/44DsH5hULQ2xi1if5Nf8H2W7PhBW14Of+VU=
Date: Tue, 24 Feb 2026 11:14:03 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-mailmap-update-e-mail-address-for-vlastimil-babka.patch removed from -mm tree
Message-Id: <20260224191403.97487C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS, mailmap: update e-mail address for Vlastimil Babka
has been removed from the -mm tree.  Its filename was
     maintainers-mailmap-update-e-mail-address-for-vlastimil-babka.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: MAINTAINERS, mailmap: update e-mail address for Vlastimil Babka
Date: Tue, 17 Feb 2026 11:21:52 +0100

Hopefully improve e-mail performance.

Link: https://lkml.kernel.org/r/20260217102151.10425-2-vbabka@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |   18 +++++++++---------
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/.mailmap~maintainers-mailmap-update-e-mail-address-for-vlastimil-babka
+++ a/.mailmap
@@ -876,6 +876,7 @@ Vivien Didelot <vivien.didelot@gmail.com
 Vlad Dogaru <ddvlad@gmail.com> <vlad.dogaru@intel.com>
 Vladimir Davydov <vdavydov.dev@gmail.com> <vdavydov@parallels.com>
 Vladimir Davydov <vdavydov.dev@gmail.com> <vdavydov@virtuozzo.com>
+Vlastimil Babka <vbabka@kernel.org> <vbabka@suse.cz>
 WangYuli <wangyuli@aosc.io> <wangyl5933@chinaunicom.cn>
 WangYuli <wangyuli@aosc.io> <wangyuli@deepin.org>
 Weiwen Hu <huweiwen@linux.alibaba.com> <sehuww@mail.scut.edu.cn>
--- a/MAINTAINERS~maintainers-mailmap-update-e-mail-address-for-vlastimil-babka
+++ a/MAINTAINERS
@@ -16656,7 +16656,7 @@ M:	Andrew Morton <akpm@linux-foundation.
 M:	David Hildenbrand <david@kernel.org>
 R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
-R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
 R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
@@ -16786,7 +16786,7 @@ M:	Andrew Morton <akpm@linux-foundation.
 M:	David Hildenbrand <david@kernel.org>
 R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
-R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
 R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
@@ -16841,7 +16841,7 @@ F:	mm/oom_kill.c
 
 MEMORY MANAGEMENT - PAGE ALLOCATOR
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Vlastimil Babka <vbabka@suse.cz>
+M:	Vlastimil Babka <vbabka@kernel.org>
 R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
 R:	Brendan Jackman <jackmanb@google.com>
@@ -16887,7 +16887,7 @@ M:	David Hildenbrand <david@kernel.org>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Rik van Riel <riel@surriel.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
-R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Harry Yoo <harry.yoo@oracle.com>
 R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
@@ -16986,7 +16986,7 @@ MEMORY MAPPING
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
-R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Jann Horn <jannh@google.com>
 R:	Pedro Falcato <pfalcato@suse.de>
 L:	linux-mm@kvack.org
@@ -17016,7 +17016,7 @@ M:	Andrew Morton <akpm@linux-foundation.
 M:	Suren Baghdasaryan <surenb@google.com>
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
-R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
@@ -17032,7 +17032,7 @@ M:	Andrew Morton <akpm@linux-foundation.
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 M:	David Hildenbrand <david@kernel.org>
-R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
 S:	Maintained
@@ -23174,7 +23174,7 @@ K:	\b(?i:rust)\b
 RUST [ALLOC]
 M:	Danilo Krummrich <dakr@kernel.org>
 R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
-R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Uladzislau Rezki <urezki@gmail.com>
 L:	rust-for-linux@vger.kernel.org
@@ -24350,7 +24350,7 @@ F:	Documentation/devicetree/bindings/nvm
 F:	drivers/nvmem/layouts/sl28vpd.c
 
 SLAB ALLOCATOR
-M:	Vlastimil Babka <vbabka@suse.cz>
+M:	Vlastimil Babka <vbabka@kernel.org>
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Christoph Lameter <cl@gentwo.org>
 R:	David Rientjes <rientjes@google.com>
_

Patches currently in -mm which might be from vbabka@kernel.org are


