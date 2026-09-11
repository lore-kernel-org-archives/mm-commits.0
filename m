Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FACE2931ED
	for <mm-commits@vger.kernel.org>; Fri, 11 Sep 2026 00:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789087723; cv=none; b=PVOJIy9O3bAcKMveRuGKRmBU7hILlSfT1Uh3ZOEd1xTlw427taq6mXvS4z2DCpYXtEjp88Y59XGuVxwBZDEHXKUigGWJsR33yax8G4Ens5yk4IW8v4C4F+LvQTR3F87PC+NYiCTPsOVr6W07I6ZZ257lb+l9JY09L+/cE2Lil+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789087723; c=relaxed/simple;
	bh=KvaFgjHXdJ+s5wQTRNna9thKF+fZ/ZTO2DKBH7xvYos=;
	h=Date:To:From:Subject:Message-Id; b=P3w/SZrkUHAMyFpwMgexint/VLUylr4u3WLbq95wqT4sK/tATkGDTLG7b9rVT1E/MtF2K3rCtfejoHnPJpayk6ZpEFXPLeQB6VsWj7apT31nlRItK99oXKmpgbS58i9IEw73UMjjbFwJSrfnvh+xTWgNqHfdUeCra3z4dBWaBEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=di/n81uW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="di/n81uW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D491F000FF;
	Fri, 11 Sep 2026 00:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789087722;
	bh=ipR9hI59nmVRyoIgHAHpBQhvpOZkMvVv76HATaRVpaI=;
	h=Date:To:From:Subject;
	b=di/n81uWne6DiDMVCULXKU77A70JTYv6iRZFUAB6NT6BQOUnktO53Txbk5YYA9BwW
	 k5xanlNaxbtPcKAvdXHXYPLe4ifRPVTb9JQSsp57nc9WYC8jvIKtqtgQDyHb0r1B1a
	 ajmpo3+rwHUIWasrLtnQX8Pqxd1MkDUHMW59fNH4=
Date: Thu, 10 Sep 2026 17:48:41 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-xu-xins-email.patch added to mm-hotfixes-unstable branch
Message-Id: <20260911004841.D9D491F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update Xu Xin's email
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-xu-xins-email.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-xu-xins-email.patch

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

maintainers-update-xu-xins-email.patch

