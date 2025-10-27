Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E695D2609D4
	for <mm-commits@vger.kernel.org>; Mon, 27 Oct 2025 23:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761607758; cv=none; b=gID5MBZZc8V0faUhm56yYtZH4tqoxy9GBTKsB3SjAYsZUh8s2HxfHqmt90arlldb06kSNt7PefI5RNo+d9TO8TD9opQRbBxp21NeDxkfQDjuRC2XzKOY19uWjf6GZDfoDj5lwd/yLePjqNis5l1TP+LMygOMT8ffLE6W9UjLLVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761607758; c=relaxed/simple;
	bh=6AYjNdX8snqdVjZfQPPxU6oOhCtk28SkqLuipCaJkDs=;
	h=Date:To:From:Subject:Message-Id; b=AGoeMybK/IA3RKc2Ukut6oj7/nV8kRK2VB+2jdogQW3O3ixxzMvvjc6PxvnYKsi9YGET4D+keGp1aq4wt2ZMoM5tUtCpdkjJy+iJQSfrnD+9XcE+6W/S/q0MrhifJNynEmkFQVof1RXdWmhnccQk68xd1G94RrXBG27bwhJQ05Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JrUQdhMY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JrUQdhMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8033CC4CEF1;
	Mon, 27 Oct 2025 23:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761607757;
	bh=6AYjNdX8snqdVjZfQPPxU6oOhCtk28SkqLuipCaJkDs=;
	h=Date:To:From:Subject:From;
	b=JrUQdhMYtKRqGVGrVA/w5hT0Sb9fgyjgMRuuECaVpk84cpVeMiqUDBsiarmPo/XVf
	 jCHQJGmsDlLyD29LKFdzR6J74RGecSSSzsvRbsSSCdo8Wl4IOdc22j/98zS6huYS6J
	 /j44C1yzbVhyyz63qgMhKBNv12ZqE2wlPrKf7n8A=
Date: Mon, 27 Oct 2025 16:29:16 -0700
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,stanley_chang@realtek.com,eleanor.lin@realtek.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-yu-chun-lin.patch added to mm-nonmm-unstable branch
Message-Id: <20251027232917.8033CC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add entry for Yu-Chun Lin
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-add-entry-for-yu-chun-lin.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-yu-chun-lin.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Yu-Chun Lin <eleanor.lin@realtek.com>
Subject: mailmap: add entry for Yu-Chun Lin
Date: Mon, 27 Oct 2025 18:03:09 +0800

Map my personal email to my business email.

Link: https://lkml.kernel.org/r/20251027100309.22035-1-eleanor.lin@realtek.com
Signed-off-by: Yu-Chun Lin <eleanor.lin@realtek.com>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Stanley Chang <stanley_chang@realtek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-yu-chun-lin
+++ a/.mailmap
@@ -855,6 +855,7 @@ Yakir Yang <kuankuan.y@gmail.com> <ykk@r
 Yanteng Si <si.yanteng@linux.dev> <siyanteng@loongson.cn>
 Ying Huang <huang.ying.caritas@gmail.com> <ying.huang@intel.com>
 Yosry Ahmed <yosry.ahmed@linux.dev> <yosryahmed@google.com>
+Yu-Chun Lin <eleanor.lin@realtek.com> <eleanor15x@gmail.com>
 Yusuke Goda <goda.yusuke@renesas.com>
 Zack Rusin <zack.rusin@broadcom.com> <zackr@vmware.com>
 Zhu Yanjun <zyjzyj2000@gmail.com> <yanjunz@nvidia.com>
_

Patches currently in -mm which might be from eleanor.lin@realtek.com are

mailmap-add-entry-for-yu-chun-lin.patch

