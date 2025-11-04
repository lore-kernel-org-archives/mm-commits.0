Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3031834C987
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 23:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762300698; cv=none; b=tv+EO28GjcDKnCwEdMygbCDVlFaYCUo78/fQ4LvAt69KBszP6sOKBctzjj/8xozXaXlm6DNiK4GP6E6JgMqnGn7GTwrWydfcLzKQnm/0ixg8hlflGc60S2Smxsh84rWe44YPlnIigvMl510UYQodmFpPuWUe1SpiCjMTsGxrxjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762300698; c=relaxed/simple;
	bh=4LKgg6OKv/Xk4RwSoktuidDigHrnZ4IiFheTM6DzWBY=;
	h=Date:To:From:Subject:Message-Id; b=hOP7SAGtlkvlYVVeTR8KvlnsG/M/ZiygDXj5I2e9/AdnRf2mRLRb0sFUjhiThtRSczDvhzdtccDVw6rEHo/xqk5orOmaZM8Cua7YVcwJURaBE+axm1ETojs1CmlCMzRSjSuAmdWg2xnWZAknSbojGsaX9S/iucUuDZpL0ZfjcKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zY01MpHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zY01MpHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B2AC116B1;
	Tue,  4 Nov 2025 23:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762300697;
	bh=4LKgg6OKv/Xk4RwSoktuidDigHrnZ4IiFheTM6DzWBY=;
	h=Date:To:From:Subject:From;
	b=zY01MpHA3E81AfBXrsbqWGP+n3zfCqvY6X70E3FK2v08YEgQwcdN7PBSIx2Y4gIO5
	 JqjjkbJu5PWHtTJcf0JElAcFeppHgqYhCkjppXvPxRkpT6Bph9gYYf//zik5Tbgtbn
	 YxmCpOWY2k9P2Bnd0qepHdNz48UGsJAIItmhoGJA=
Date: Tue, 04 Nov 2025 15:58:17 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-david-hildenbrands-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20251104235817.D7B2AC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update David Hildenbrand's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-david-hildenbrands-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-david-hildenbrands-email-address.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: MAINTAINERS: update David Hildenbrand's email address
Date: Mon, 3 Nov 2025 11:36:59 +0100

Switch to kernel.org email address as I will be leaving Red Hat.  The old
address will remain active until end of January 2026, so performing the
change now should make sure that most mails will reach me.

Link: https://lkml.kernel.org/r/20251103103659.379335-1-david@kernel.org
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |   28 ++++++++++++++--------------
 2 files changed, 15 insertions(+), 14 deletions(-)

--- a/.mailmap~maintainers-update-david-hildenbrands-email-address
+++ a/.mailmap
@@ -206,6 +206,7 @@ Danilo Krummrich <dakr@kernel.org> <dakr
 David Brownell <david-b@pacbell.net>
 David Collins <quic_collinsd@quicinc.com> <collinsd@codeaurora.org>
 David Heidelberg <david@ixit.cz> <d.okias@gmail.com>
+David Hildenbrand <david@kernel.org> <david@redhat.com>
 David Rheinsberg <david@readahead.eu> <dh.herrmann@gmail.com>
 David Rheinsberg <david@readahead.eu> <dh.herrmann@googlemail.com>
 David Rheinsberg <david@readahead.eu> <david.rheinsberg@gmail.com>
--- a/MAINTAINERS~maintainers-update-david-hildenbrands-email-address
+++ a/MAINTAINERS
@@ -11525,7 +11525,7 @@ F:	include/linux/platform_data/huawei-ga
 HUGETLB SUBSYSTEM
 M:	Muchun Song <muchun.song@linux.dev>
 M:	Oscar Salvador <osalvador@suse.de>
-R:	David Hildenbrand <david@redhat.com>
+R:	David Hildenbrand <david@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-mm-hugepages
@@ -13731,7 +13731,7 @@ KERNEL VIRTUAL MACHINE for s390 (KVM/s39
 M:	Christian Borntraeger <borntraeger@linux.ibm.com>
 M:	Janosch Frank <frankja@linux.ibm.com>
 M:	Claudio Imbrenda <imbrenda@linux.ibm.com>
-R:	David Hildenbrand <david@redhat.com>
+R:	David Hildenbrand <david@kernel.org>
 L:	kvm@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git
@@ -16218,7 +16218,7 @@ T:	git git://git.kernel.org/pub/scm/linu
 F:	drivers/devfreq/tegra30-devfreq.c
 
 MEMORY HOT(UN)PLUG
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 M:	Oscar Salvador <osalvador@suse.de>
 L:	linux-mm@kvack.org
 S:	Maintained
@@ -16243,7 +16243,7 @@ F:	tools/mm/
 
 MEMORY MANAGEMENT - CORE
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Vlastimil Babka <vbabka@suse.cz>
@@ -16299,7 +16299,7 @@ F:	mm/execmem.c
 
 MEMORY MANAGEMENT - GUP (GET USER PAGES)
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 R:	Jason Gunthorpe <jgg@nvidia.com>
 R:	John Hubbard <jhubbard@nvidia.com>
 R:	Peter Xu <peterx@redhat.com>
@@ -16315,7 +16315,7 @@ F:	tools/testing/selftests/mm/gup_test.c
 
 MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 R:	Xu Xin <xu.xin16@zte.com.cn>
 R:	Chengming Zhou <chengming.zhou@linux.dev>
 L:	linux-mm@kvack.org
@@ -16331,7 +16331,7 @@ F:	mm/mm_slot.h
 
 MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Matthew Brost <matthew.brost@intel.com>
 R:	Joshua Hahn <joshua.hahnjy@gmail.com>
@@ -16371,7 +16371,7 @@ F:	mm/workingset.c
 
 MEMORY MANAGEMENT - MISC
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Vlastimil Babka <vbabka@suse.cz>
@@ -16459,7 +16459,7 @@ F:	mm/shuffle.h
 MEMORY MANAGEMENT - RECLAIM
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Johannes Weiner <hannes@cmpxchg.org>
-R:	David Hildenbrand <david@redhat.com>
+R:	David Hildenbrand <david@kernel.org>
 R:	Michal Hocko <mhocko@kernel.org>
 R:	Qi Zheng <zhengqi.arch@bytedance.com>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
@@ -16472,7 +16472,7 @@ F:	mm/workingset.c
 
 MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Rik van Riel <riel@surriel.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
@@ -16517,7 +16517,7 @@ F:	mm/swapfile.c
 
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
@@ -16619,7 +16619,7 @@ MEMORY MAPPING - MADVISE (MEMORY ADVICE)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 R:	Vlastimil Babka <vbabka@suse.cz>
 R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
@@ -27084,7 +27084,7 @@ F:	net/vmw_vsock/virtio_transport_common
 
 VIRTIO BALLOON
 M:	"Michael S. Tsirkin" <mst@redhat.com>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 L:	virtualization@lists.linux.dev
 S:	Maintained
 F:	drivers/virtio/virtio_balloon.c
@@ -27239,7 +27239,7 @@ F:	drivers/iommu/virtio-iommu.c
 F:	include/uapi/linux/virtio_iommu.h
 
 VIRTIO MEM DRIVER
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 L:	virtualization@lists.linux.dev
 S:	Maintained
 W:	https://virtio-mem.gitlab.io/
_

Patches currently in -mm which might be from david@kernel.org are

maintainers-update-david-hildenbrands-email-address.patch

