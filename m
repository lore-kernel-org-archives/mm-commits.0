Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7696712B9B
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BoEgvACL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA28BC433C7;
	Fri, 29 Dec 2023 19:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703876726;
	bh=oHbG8zxWAY0q0H6Jn14n7I4/3xZ+kXjUXFqY0Sfq85w=;
	h=Date:To:From:Subject:From;
	b=BoEgvACLwCPkmVJG2fp2deYNIaelR8w+t37zn6WsakL72vLaTTxEi6QLLTPmGO6nv
	 /zK3LyAlx9jbXzvB24dyev5bEumUWEHoJmPAQrbeYXXctTu9vYxHjEodfIeeNzdCmR
	 JCANUP1DeIvbEK6vreqQHVKyZgipl5X5yDvevFxY=
Date: Fri, 29 Dec 2023 11:05:26 -0800
To: mm-commits@vger.kernel.org,naoya.horiguchi@nec.com,linmiaohe@huawei.com,david@redhat.com,nao.horiguchi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin-v2.patch removed from -mm tree
Message-Id: <20231229190526.DA28BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin-v2
has been removed from the -mm tree.  Its filename was
     maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin-v2.patch

This patch was dropped because it was folded into maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin.patch

------------------------------------------------------
From: Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin-v2
Date: Sat, 23 Dec 2023 12:11:15 +0900

update to keep myself as a reviewer 

Link: https://lkml.kernel.org/r/20231223031115.GA2883156@u2004
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin-v2
+++ a/MAINTAINERS
@@ -9784,6 +9784,7 @@ F:	drivers/media/platform/st/sti/hva
 
 HWPOISON MEMORY FAILURE HANDLING
 M:	Miaohe Lin <linmiaohe@huawei.com>
+R:	Naoya Horiguchi <naoya.horiguchi@nec.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/hwpoison-inject.c
_

Patches currently in -mm which might be from nao.horiguchi@gmail.com are

maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin.patch

