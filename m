Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E874C15B136
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 20:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715027408; cv=none; b=vGjy0sUQFXFOMLAdjCAFHf+jX9VtR13WB/91U/SWJp6CzCeOBNOr+rLWCuIgMgHWpCDOozwItjDrArZo7BWGUk/lPLcCa9rZQQCV9PRa19Eeluur+d1l9hVMn930XIgbFtJImL63aPAGbv5yBjWnA4M4wyUVthyGwX4BtFGZqsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715027408; c=relaxed/simple;
	bh=bbYiChKpJYNYRgYh+VbMf80txzXP6T7437Yi2/keMn0=;
	h=Date:To:From:Subject:Message-Id; b=gwBTLTfc6RsZUO6+3uQbZUk2IK38nWUt6KZs3hF9/XwMgoJbOEPNjshaVQc7LyOoIpfw19r/DRJlP/sQJRdbueaONQFWNyllwS1cw+KjbYHJl7bDrVZSik/+72rvLKzd1Gz/E8sCTmRdzbuxp0wY2yeXwhTlHMY9YzdCn6gAqbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V+EQ9M2U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V+EQ9M2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62421C116B1;
	Mon,  6 May 2024 20:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715027407;
	bh=bbYiChKpJYNYRgYh+VbMf80txzXP6T7437Yi2/keMn0=;
	h=Date:To:From:Subject:From;
	b=V+EQ9M2UR4URF3CxSqm9O6WiH2oku/RojN1sz467vc4rZLyXDXVCq06I0fYTpp5Td
	 i27WvnxDl1cjUrcU0cqB2pmIXrpbi24iKTtXChMNUYOXu4d1ydrZ/gKSLbFl7cfZZW
	 Y50DLV/Q9vHy6CYfBroic/ZeSmXXncHSiUeB2qbg=
Date: Mon, 06 May 2024 13:30:06 -0700
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-barry-song.patch added to mm-hotfixes-unstable branch
Message-Id: <20240506203007.62421C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add entry for Barry Song
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entry-for-barry-song.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-barry-song.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mailmap: add entry for Barry Song
Date: Mon, 6 May 2024 16:20:09 +1200

Include a .mailmap entry to synchronize with both my past and current
emails.  Among them, three business mailboxes are dead.

Link: https://lkml.kernel.org/r/20240506042009.10854-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    5 +++++
 1 file changed, 5 insertions(+)

--- a/.mailmap~mailmap-add-entry-for-barry-song
+++ a/.mailmap
@@ -87,6 +87,11 @@ Baolin Wang <baolin.wang@linux.alibaba.c
 Baolin Wang <baolin.wang@linux.alibaba.com> <baolin.wang@spreadtrum.com>
 Baolin Wang <baolin.wang@linux.alibaba.com> <baolin.wang@unisoc.com>
 Baolin Wang <baolin.wang@linux.alibaba.com> <baolin.wang7@gmail.com>
+Barry Song <baohua@kernel.org> <21cnbao@gmail.com>
+Barry Song <baohua@kernel.org> <v-songbaohua@oppo.com>
+Barry Song <baohua@kernel.org> <song.bao.hua@hisilicon.com>
+Barry Song <baohua@kernel.org> <Baohua.Song@csr.com>
+Barry Song <baohua@kernel.org> <barry.song@analog.com>
 Bart Van Assche <bvanassche@acm.org> <bart.vanassche@sandisk.com>
 Bart Van Assche <bvanassche@acm.org> <bart.vanassche@wdc.com>
 Bartosz Golaszewski <brgl@bgdev.pl> <bgolaszewski@baylibre.com>
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mailmap-add-entry-for-barry-song.patch

