Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795158907;
	b=pd/HD53SVY8xoQZnyLhLW92DpHOX8VZj/BFMAWzVobwnHrCBRQEg2xsyQjcQKMONvnqK
	 FReNoy+C/iCuT9n+rUJzoHm4wlmoc43oQezPaLwLBVME8QdaPjhX0dwz+LAAR4hyqjPgl
	 +nV6x4cZWAd5WHCw8lC2+b3pE9LsFL2w4iOpsab1+kb+1yI7Iyp96iOLNKom+sLm93UkR
	 kDDlyDEvtLKfI4XxMs2F+Dsk6+7Fj0LS8Y9HZ3XYsDPOFozTFVkb28ESXq6XmejRfpxUN
	 pmTcJTyv2EnZZgRd5s7jwvtNQiwRjaUowIsX091oX5pqgx9qulUGwLMk8FO9QdnbOHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795158907;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=PChoPG/4FcswYt7gDGaRw+7Au91kxzVsnrlCkS7cz8w=;
	b=tH4BKgNepF0+1+egyoxaEXgDKv7gaDeDfdGVqDxpAwemCQNjKDn6UFcu9/dSAmZzQeHB
	 1FoKqjWEblXjr4HB80+utQS6IzqtIyc7p7CM/32CkJu0m0u5XxG0v/P2q6xhJdxiqPkUi
	 112jFu87eajmGCGqYSRoR898gHD3fTHAgPqlO8nUoqZdkVOjYkYrmjMfwC8slLCsNaYmZ
	 H5C7aWKOhBAwRlhuGXpE5MuwZS97hoNVsFCvLIrdmntlxqlyndgoRzrEt3IrX63OjYRwe
	 6mjpylXbXFC+ptcuvB4Vt3NGuCQe9I4/YLE767Al84o4uWqKKheGvORKD98wN/MddMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ySECzsRQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABF4606A320
	for <mm-commits@vger.kernel.org>; Fri, 20 Nov 2026 07:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ySECzsRQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C51D1F000C4;
	Fri, 20 Nov 2026 07:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795158906;
	bh=PChoPG/4FcswYt7gDGaRw+7Au91kxzVsnrlCkS7cz8w=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=ySECzsRQQrMtm4FUnVH5W1/ZnpKMvSLlI7tV/1AQw4Tb7sR1dkXQHdF5yEbPObTNx
	 aYvZfzq2/Ln/hyav3xGcjW7F320MU0Vz/z9sx0EA5xfTb4vKrh3U+AC6QOMiA4jVBw
	 tT7B0p7WcoEP1sS3rCSXGMHH2c954oeQhtiEKzb0=
Date: Thu, 19 Nov 2026 23:15:06 -0800
To: mm-commits@vger.kernel.org,jeff.johnson@oss.qualcomm.com,
	yuanfang.zhang@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261120070941.2814556-1-yuanfang.zhang@oss.qualcomm.com>
References: <20261120070941.2814556-1-yuanfang.zhang@oss.qualcomm.com>
Subject: + mailmap-add-entry-for-yuanfang-zhang.patch added to mm-nonmm-hotfixes-unstable branch
Message-Id: <20261120071506.8C51D1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mailmap: add entry for Yuanfang Zhang
has been added to the -mm mm-nonmm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entry-for-yuanfang-zhang.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-yuanfang-zhang.patch

This patch will later appear in the mm-nonmm-hotfixes-unstable branch at
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
From: Yuanfang Zhang <yuanfang.zhang@oss.qualcomm.com>
Subject: mailmap: add entry for Yuanfang Zhang
Date: Thu, 19 Nov 2026 23:09:41 -0800

Map past iterations of my e-mail addresses to the current one.

Link: https://patch.msgid.link/20261120070941.2814556-1-yuanfang.zhang@oss.qualcomm.com
Signed-off-by: Yuanfang Zhang <yuanfang.zhang@oss.qualcomm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-yuanfang-zhang
+++ a/.mailmap
@@ -1045,6 +1045,7 @@ Yixun Lan <dlan@kernel.org> <dlan@gentoo
 Yixun Lan <dlan@kernel.org> <yixun.lan@amlogic.com>
 Yosry Ahmed <yosry@kernel.org> <yosryahmed@google.com>
 Yosry Ahmed <yosry@kernel.org> <yosry.ahmed@linux.dev>
+Yuanfang Zhang <yuanfang.zhang@oss.qualcomm.com> <quic_yuanfang@quicinc.com>
 Yu-Chun Lin <eleanor.lin@realtek.com> <eleanor15x@gmail.com>
 Yusuke Goda <goda.yusuke@renesas.com>
 Zack Rusin <zack.rusin@broadcom.com> <zackr@vmware.com>
_

Patches currently in -mm which might be from yuanfang.zhang@oss.qualcomm.com are

mailmap-add-entry-for-yuanfang-zhang.patch

