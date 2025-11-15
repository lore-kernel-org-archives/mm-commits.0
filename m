Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB601DE4E1
	for <mm-commits@vger.kernel.org>; Sat, 15 Nov 2025 18:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763232758; cv=none; b=f5p2ih0J6XS0o42kloribeDCou9Q9wOWj9FoYXlijf6o5NTEa8d7teJCQih6Ajhmu+sTmC+MoODgjO3gfy3YOLg//n9T9iuWwFCKFA1jXT2oRIPOERqyha8CnqgtiCcghJUi7UsL00mFxO6vEsCK5FQNeQVAseqeUJ+iZZgjVcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763232758; c=relaxed/simple;
	bh=AQJogMLJYyiTIQVf83hekTV5X2oRytlBKq4IbQchCFQ=;
	h=Date:To:From:Subject:Message-Id; b=TEGib5RJzwHDSZ/keWXM/6/Ifs+t2gYtHqA66p5R05wG3kEx+kfK47g6NJyU4dJl5U6ibFe9X4GpcotoiBDI2lT3Ae8phs0CHxlFpV3Oslgh6C3wq1N8R7SyIhL3pF8PrsfYopbElQ6qBY64JPeTA04fo0ifet8tOIgQr77ynXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aVvi2YjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aVvi2YjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA88FC2BC86;
	Sat, 15 Nov 2025 18:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763232757;
	bh=AQJogMLJYyiTIQVf83hekTV5X2oRytlBKq4IbQchCFQ=;
	h=Date:To:From:Subject:From;
	b=aVvi2YjMX8q9p5kVQNvZQ4Fkwy9lOhzBfoXfZz5VilG/F2L4hPo+qDazuk9CaKxRu
	 EF6fEWBysDjfpD1+qpZLXE4yZJg7VNfzAAqqMd87Ww9Nw7WOHxkPB4qHNfSvnBCn1u
	 wDBJSjtZxVaBKWkbIBeQ9ODbXUrc/O1qzJct8I8I=
Date: Sat, 15 Nov 2025 10:52:37 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-david-hildenbrands-email-address.patch removed from -mm tree
Message-Id: <20251115185237.CA88FC2BC86@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update David Hildenbrand's email address
has been removed from the -mm tree.  Its filename was
     maintainers-update-david-hildenbrands-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -11526,7 +11526,7 @@ F:	include/linux/platform_data/huawei-ga
 HUGETLB SUBSYSTEM
 M:	Muchun Song <muchun.song@linux.dev>
 M:	Oscar Salvador <osalvador@suse.de>
-R:	David Hildenbrand <david@redhat.com>
+R:	David Hildenbrand <david@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-mm-hugepages
@@ -13733,7 +13733,7 @@ KERNEL VIRTUAL MACHINE for s390 (KVM/s39
 M:	Christian Borntraeger <borntraeger@linux.ibm.com>
 M:	Janosch Frank <frankja@linux.ibm.com>
 M:	Claudio Imbrenda <imbrenda@linux.ibm.com>
-R:	David Hildenbrand <david@redhat.com>
+R:	David Hildenbrand <david@kernel.org>
 L:	kvm@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git
@@ -16220,7 +16220,7 @@ T:	git git://git.kernel.org/pub/scm/linu
 F:	drivers/devfreq/tegra30-devfreq.c
 
 MEMORY HOT(UN)PLUG
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 M:	Oscar Salvador <osalvador@suse.de>
 L:	linux-mm@kvack.org
 S:	Maintained
@@ -16245,7 +16245,7 @@ F:	tools/mm/
 
 MEMORY MANAGEMENT - CORE
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Vlastimil Babka <vbabka@suse.cz>
@@ -16301,7 +16301,7 @@ F:	mm/execmem.c
 
 MEMORY MANAGEMENT - GUP (GET USER PAGES)
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 R:	Jason Gunthorpe <jgg@nvidia.com>
 R:	John Hubbard <jhubbard@nvidia.com>
 R:	Peter Xu <peterx@redhat.com>
@@ -16317,7 +16317,7 @@ F:	tools/testing/selftests/mm/gup_test.c
 
 MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 R:	Xu Xin <xu.xin16@zte.com.cn>
 R:	Chengming Zhou <chengming.zhou@linux.dev>
 L:	linux-mm@kvack.org
@@ -16333,7 +16333,7 @@ F:	mm/mm_slot.h
 
 MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Matthew Brost <matthew.brost@intel.com>
 R:	Joshua Hahn <joshua.hahnjy@gmail.com>
@@ -16373,7 +16373,7 @@ F:	mm/workingset.c
 
 MEMORY MANAGEMENT - MISC
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Vlastimil Babka <vbabka@suse.cz>
@@ -16461,7 +16461,7 @@ F:	mm/shuffle.h
 MEMORY MANAGEMENT - RECLAIM
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Johannes Weiner <hannes@cmpxchg.org>
-R:	David Hildenbrand <david@redhat.com>
+R:	David Hildenbrand <david@kernel.org>
 R:	Michal Hocko <mhocko@kernel.org>
 R:	Qi Zheng <zhengqi.arch@bytedance.com>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
@@ -16474,7 +16474,7 @@ F:	mm/workingset.c
 
 MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Rik van Riel <riel@surriel.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
@@ -16519,7 +16519,7 @@ F:	mm/swapfile.c
 
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
@@ -16621,7 +16621,7 @@ MEMORY MAPPING - MADVISE (MEMORY ADVICE)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 R:	Vlastimil Babka <vbabka@suse.cz>
 R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
@@ -27088,7 +27088,7 @@ F:	net/vmw_vsock/virtio_transport_common
 
 VIRTIO BALLOON
 M:	"Michael S. Tsirkin" <mst@redhat.com>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 L:	virtualization@lists.linux.dev
 S:	Maintained
 F:	drivers/virtio/virtio_balloon.c
@@ -27243,7 +27243,7 @@ F:	drivers/iommu/virtio-iommu.c
 F:	include/uapi/linux/virtio_iommu.h
 
 VIRTIO MEM DRIVER
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 L:	virtualization@lists.linux.dev
 S:	Maintained
 W:	https://virtio-mem.gitlab.io/
_

Patches currently in -mm which might be from david@kernel.org are


