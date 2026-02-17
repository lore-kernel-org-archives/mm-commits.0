Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9075529B79B
	for <mm-commits@vger.kernel.org>; Tue, 17 Feb 2026 18:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771354398; cv=none; b=kjAK++MumqJeFcUpx12NEWkOMIvXRWBAniVjHHQAVrNOen9oGjgdazJ5rp3n3lGwV65uUB7EakQNtcDo+xWSmvt0jPtj5ScF1ZsXvGo13X8zGjCYSzW9UcHaYhiz3MgNQOv0fGv9NgccoDb+4ZIEb0Nq77ggGl8I+rkjq6pvg4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771354398; c=relaxed/simple;
	bh=oHJY6rL8kOTswovVxpgcXHYXnyMqlBRpxmFizWrmkEU=;
	h=Date:To:From:Subject:Message-Id; b=n/a5A3Rlbg1f3//k14EL7YDUAg0NvJNc9GZkNiFYIPaSfkALFdA98SVy7vAht705dbYEs9dcPCOhXMnX1dtf5ywB0ALxa83EnBzC+sSDZttEKf7XJDcQj/5ZzTKx8N/ZHdeSZV6mwujtmMSLUUaVio9uVriKJb179Zw4Xns55Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z/aBPkzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z/aBPkzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D70C4CEF7;
	Tue, 17 Feb 2026 18:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771354398;
	bh=oHJY6rL8kOTswovVxpgcXHYXnyMqlBRpxmFizWrmkEU=;
	h=Date:To:From:Subject:From;
	b=z/aBPkzMZgcBG05dwGeNZcoEVyUXYcPdrVLAMJsMPLmRY+s8f+EXu+vYPPvucYfUG
	 ZPdyZxrXznqYhymOf1n0HAYEc36X7QrEzn4ZGbBQuQ9UZy/UxTkRnB6Ub/HboFyeuZ
	 oU2aIe+jk86IgAZbh7uUWuLX94UmioOOmZ+rd+l0=
Date: Tue, 17 Feb 2026 10:53:17 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-mailmap-update-e-mail-address-for-vlastimil-babka.patch added to mm-hotfixes-unstable branch
Message-Id: <20260217185318.44D70C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS, mailmap: update e-mail address for Vlastimil Babka
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-mailmap-update-e-mail-address-for-vlastimil-babka.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-mailmap-update-e-mail-address-for-vlastimil-babka.patch

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
@@ -868,6 +868,7 @@ Vivien Didelot <vivien.didelot@gmail.com
 Vlad Dogaru <ddvlad@gmail.com> <vlad.dogaru@intel.com>
 Vladimir Davydov <vdavydov.dev@gmail.com> <vdavydov@parallels.com>
 Vladimir Davydov <vdavydov.dev@gmail.com> <vdavydov@virtuozzo.com>
+Vlastimil Babka <vbabka@kernel.org> <vbabka@suse.cz>
 WangYuli <wangyuli@aosc.io> <wangyl5933@chinaunicom.cn>
 WangYuli <wangyuli@aosc.io> <wangyuli@deepin.org>
 Weiwen Hu <huweiwen@linux.alibaba.com> <sehuww@mail.scut.edu.cn>
--- a/MAINTAINERS~maintainers-mailmap-update-e-mail-address-for-vlastimil-babka
+++ a/MAINTAINERS
@@ -16463,7 +16463,7 @@ M:	Andrew Morton <akpm@linux-foundation.
 M:	David Hildenbrand <david@kernel.org>
 R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
-R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
 R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
@@ -16593,7 +16593,7 @@ M:	Andrew Morton <akpm@linux-foundation.
 M:	David Hildenbrand <david@kernel.org>
 R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
-R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
 R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
@@ -16648,7 +16648,7 @@ F:	mm/oom_kill.c
 
 MEMORY MANAGEMENT - PAGE ALLOCATOR
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Vlastimil Babka <vbabka@suse.cz>
+M:	Vlastimil Babka <vbabka@kernel.org>
 R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
 R:	Brendan Jackman <jackmanb@google.com>
@@ -16695,7 +16695,7 @@ M:	David Hildenbrand <david@kernel.org>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Rik van Riel <riel@surriel.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
-R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Harry Yoo <harry.yoo@oracle.com>
 R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
@@ -16794,7 +16794,7 @@ MEMORY MAPPING
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
-R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Jann Horn <jannh@google.com>
 R:	Pedro Falcato <pfalcato@suse.de>
 L:	linux-mm@kvack.org
@@ -16824,7 +16824,7 @@ M:	Andrew Morton <akpm@linux-foundation.
 M:	Suren Baghdasaryan <surenb@google.com>
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
-R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
@@ -16840,7 +16840,7 @@ M:	Andrew Morton <akpm@linux-foundation.
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 M:	David Hildenbrand <david@kernel.org>
-R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
 S:	Maintained
@@ -22916,7 +22916,7 @@ K:	\b(?i:rust)\b
 RUST [ALLOC]
 M:	Danilo Krummrich <dakr@kernel.org>
 R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
-R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Uladzislau Rezki <urezki@gmail.com>
 L:	rust-for-linux@vger.kernel.org
@@ -24065,7 +24065,7 @@ F:	Documentation/devicetree/bindings/nvm
 F:	drivers/nvmem/layouts/sl28vpd.c
 
 SLAB ALLOCATOR
-M:	Vlastimil Babka <vbabka@suse.cz>
+M:	Vlastimil Babka <vbabka@kernel.org>
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Christoph Lameter <cl@gentwo.org>
 R:	David Rientjes <rientjes@google.com>
_

Patches currently in -mm which might be from vbabka@kernel.org are

maintainers-mailmap-update-e-mail-address-for-vlastimil-babka.patch

