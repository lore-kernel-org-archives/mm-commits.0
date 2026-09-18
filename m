Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CAB45D18C
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 05:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789710246; cv=none; b=ob9YBMq4F8QEu56RcP1E3h0D1cCLbbDuHs0gXjk4vJJubv8rOylwa2blhf8VYCunhT6npYAsyqy5loha5mw+VXFMy/nrny37KjKh2aMjd7723yjb9heqNn9wrcZzjGDESId+s6M5tXm7NMgqu1r5IPCONRqbbhaM6Y25/H7fOqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789710246; c=relaxed/simple;
	bh=+KaWl6pvO2nHgUfUhTNDUZYzuWEZ3uOUBRW3Ncv4W6g=;
	h=Date:To:From:Subject:Message-Id; b=YXEMeSlcTGtCFI8WNAAWApURV7z7R98vJcMzjSKpRHx1Ql7VhiyWIXo21icEELomG9Sw7XdxjjwOjlaE/YCVu+D/sbFIpUJ5ouF+muBq/5S6V6DXmO1YSzVPD0+litjmOQ66XmLmu3ahsIPRrMcD24p3II5Eip4E490rhAActLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zjWtpJfC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zjWtpJfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF371F000FF;
	Fri, 18 Sep 2026 05:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789710244;
	bh=ufSq8uPKKfD4Doa8MaSSbnco0nnL4biWA4ahgTEaeqA=;
	h=Date:To:From:Subject;
	b=zjWtpJfC7E5fV523WQUGZBIWyKd2+SOJBmvgcH2L64Uum4qCI2MQS70ejW21RZvSp
	 Ltf3QEcPa9hk/1cvhBXNRGnyqgOJrYX+8+uC/jjMBL2fZn5L9tQIQuGUn+QnSjBDZo
	 W9idCcuXiGm6qr/ajst/tr8Ps6PalpqNyXiumxzo=
Date: Thu, 17 Sep 2026 22:44:04 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-xu-xins-email.patch removed from -mm tree
Message-Id: <20260918054404.AEF371F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update Xu Xin's email
has been removed from the -mm tree.  Its filename was
     maintainers-update-xu-xins-email.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xu Xin <xu.xin16@zte.com.cn>
Subject: MAINTAINERS: update Xu Xin's email
Date: Mon, 7 Sep 2026 14:53:42 +0800 (CST)

Now I'm moving to the @linux.dev account, so map my old email addresses
and update them to my new address.

Link: https://lore.kernel.org/20260907145342529uOGtNYWTAzrSCFnghfgCb@zte.com.cn
Signed-off-by: Xu Xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    2 ++
 MAINTAINERS |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-update-xu-xins-email
+++ a/.mailmap
@@ -980,6 +980,8 @@ Wesley Cheng <quic_wcheng@quicinc.com> <
 Will Deacon <will@kernel.org> <will.deacon@arm.com>
 Wolfram Sang <wsa@kernel.org> <w.sang@pengutronix.de>
 Wolfram Sang <wsa@kernel.org> <wsa@the-dreams.de>
+Xu Xin <xu.xin@linux.dev> <xu.xin16@zte.com.cn>
+Xu Xin <xu.xin@linux.dev> xu xin <cgel.zte@gmail.com>
 Yakir Yang <kuankuan.y@gmail.com> <ykk@rock-chips.com>
 Yanteng Si <si.yanteng@linux.dev> <siyanteng@loongson.cn>
 Ying Huang <huang.ying.caritas@gmail.com> <ying.huang@intel.com>
--- a/MAINTAINERS~maintainers-update-xu-xins-email
+++ a/MAINTAINERS
@@ -17192,7 +17192,7 @@ F:	tools/testing/selftests/mm/gup_test.c
 MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
-R:	Xu Xin <xu.xin16@zte.com.cn>
+R:	Xu Xin <xu.xin@linux.dev>
 R:	Chengming Zhou <chengming.zhou@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are


