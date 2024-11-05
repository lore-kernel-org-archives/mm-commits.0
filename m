Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B17F36AEC
	for <mm-commits@vger.kernel.org>; Tue,  5 Nov 2024 03:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730776543; cv=none; b=hIoZkHk3G1Nb+6OtM/tDzHgH9KIDMI+jUb/lmMPO5ubhVE22oUiKP6bboOcBuRrqJuzL61e5rus3zKZi7/9RfSgjWVZh2nnBwo5esO0rXfbmPNTg0Nciia8YdsbM1jx+VFdEyfBtuxUHKkTrPouGQKm4bibmI0CHWcAvFM4Q9tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730776543; c=relaxed/simple;
	bh=u3TH88a0Coudg4zsJUDLrMndGyfRiqKzhHK8JPsLATs=;
	h=Date:To:From:Subject:Message-Id; b=Vy3lw59bpGQ7cND0dhl/QMF8EHFXjCq7p2CXuQMYX4d1/6+e3FkZhTD4GKnTC80hQXajjoZMtV+dFD4qolnqWqN8Wcvx1GA6VAoWtNBGLDZRav3Xx1PeSLkgu+NvNzxMYw3VIlfBGtUfDXMxjHv5Gly0VEuvKkmUT0oLBVya1SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zuewtc//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zuewtc//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7F7C4CECE;
	Tue,  5 Nov 2024 03:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730776543;
	bh=u3TH88a0Coudg4zsJUDLrMndGyfRiqKzhHK8JPsLATs=;
	h=Date:To:From:Subject:From;
	b=Zuewtc//cXMHLO5j00M9lv6hDtpQ1FQrt71hK75aw904aI/2kdW8aWTnn7sHF3PdT
	 GXL38f0tYSUyhvYL1Fd0tQpFLwOL0r2Rs2Y2FUYy/r2y361ogZ6w/lFyurN3FQae32
	 op3MUgY6cHltIujpBl7hEiLXJXmSzx6FhnPZbdUU=
Date: Mon, 04 Nov 2024 19:15:42 -0800
To: mm-commits@vger.kernel.org,qmo@kernel.org,neeraj.upadhyay@kernel.org,nao.horiguchi@gmail.com,m.othacehe@gmail.com,matttbe@kernel.org,matt@ranostay.sg,kees@kernel.org,geliang@kernel.org,elder@kernel.org,davem@davemloft.net,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-thorsten-blum.patch added to mm-hotfixes-unstable branch
Message-Id: <20241105031542.ED7F7C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add entry for Thorsten Blum
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entry-for-thorsten-blum.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-thorsten-blum.patch

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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: mailmap: add entry for Thorsten Blum
Date: Mon, 4 Nov 2024 00:44:09 +0100

Map my previously used email address to my @linux.dev address.

Link: https://lkml.kernel.org/r/20241103234411.2522-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Alex Elder <elder@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Geliang Tang <geliang@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Mathieu Othacehe <m.othacehe@gmail.com>
Cc: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Cc: Matt Ranostay <matt@ranostay.sg>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
Cc: Quentin Monnet <qmo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-thorsten-blum
+++ a/.mailmap
@@ -665,6 +665,7 @@ Tomeu Vizoso <tomeu@tomeuvizoso.net> <to
 Thomas Graf <tgraf@suug.ch>
 Thomas Körper <socketcan@esd.eu> <thomas.koerper@esd.eu>
 Thomas Pedersen <twp@codeaurora.org>
+Thorsten Blum <thorsten.blum@linux.dev> <thorsten.blum@toblux.com>
 Tiezhu Yang <yangtiezhu@loongson.cn> <kernelpatch@126.com>
 Tingwei Zhang <quic_tingwei@quicinc.com> <tingwei@codeaurora.org>
 Tirupathi Reddy <quic_tirupath@quicinc.com> <tirupath@codeaurora.org>
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

mailmap-add-entry-for-thorsten-blum.patch
mm-swap-use-str_true_false-helper-function.patch
mm-page_alloc-use-str_off_on-helper-in-build_all_zonelists.patch
mm-show_mem-use-str_yes_no-helper-in-show_free_areas.patch
ipc-msg-replace-one-element-array-with-flexible-array-member.patch

