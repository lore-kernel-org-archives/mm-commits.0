Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C70385
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qHEefkMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4641EC433C7;
	Mon, 11 Dec 2023 00:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702255306;
	bh=0RZTPY6FUcyYE+P5NoStM2OxeQ1VQgegFLVgU58DmKI=;
	h=Date:To:From:Subject:From;
	b=qHEefkMhrdksDxOdekRRhQIni2lk/opv5MqHkILxa3vBlVt3Lco5kWKF2CEgWyfYB
	 AkZw7B168nHmy0MsPe86PedQJf+Us5WyY6UsiSUHa5PHFn8g/eETlyFkgGMSDaySTD
	 brGIuAvjuU1lS0xYUfd3ICuhf0KMjzbn0gmLUocA=
Date: Sun, 10 Dec 2023 16:41:45 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,mirq-linux@rere.qmqm.pl,avagin@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl-v3.patch removed from -mm tree
Message-Id: <20231211004146.4641EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl-v3
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl-v3.patch

This patch was dropped because it was folded into fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl.patch

------------------------------------------------------
From: Andrei Vagin <avagin@google.com>
Subject: fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl-v3
Date: Tue, 7 Nov 2023 08:41:37 -0800

update tools/include/uapi/linux/fs.h

Link: https://lkml.kernel.org/r/20231107164139.576046-1-avagin@google.com
Signed-off-by: Andrei Vagin <avagin@google.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/uapi/linux/fs.h |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/include/uapi/linux/fs.h~fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl-v3
+++ a/tools/include/uapi/linux/fs.h
@@ -316,6 +316,7 @@ typedef int __bitwise __kernel_rwf_t;
 #define PAGE_IS_SWAPPED		(1 << 4)
 #define PAGE_IS_PFNZERO		(1 << 5)
 #define PAGE_IS_HUGE		(1 << 6)
+#define PAGE_IS_SOFT_DIRTY	(1 << 7)
 
 /*
  * struct page_region - Page region with flags
_

Patches currently in -mm which might be from avagin@google.com are

fs-proc-task_mmu-report-soft_dirty-bits-through-the-pagemap_scan-ioctl.patch
selftests-mm-check-that-pagemap_scan-returns-correct-categories.patch
selftests-mm-check-that-pagemap_scan-returns-correct-categories-fix.patch

