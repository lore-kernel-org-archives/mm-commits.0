Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795165672;
	b=USgc1g7I/8r2KKNgExr+AHPoPp7RZDkxJaWlqe/auJVdY1NHpuq4Rw/aNVMMqok8BD0c
	 66NvdRNqRHAy2VUHnmH881KuwhcLOroYOfIWWvF1eH/E+61zHZpa79UadBOz+5m1Gb65Z
	 6rDJcLduOk56FF2WqjHlpBynTAnHEVVQrhMVEKyFcp6xRZfJTPE+EAlUX+Z5Gh3hN/30H
	 Kp5kPKwg0D5CLiW9qX/u7W/86ptAFQPjDPIeLarYwy2u7Gzpfn+mXauqtvgrtFIk+qto7
	 vmhpN2o2JE2BMSdhhrMGDjNfaiV0KZPNSiRQ1VXmT70z1P5oakG5sxJcXKqzVF7TWnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795165672;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=l/eB1vsONW+011LFr85KTA1f4IN3BjfmOQIagFw6ifw=;
	b=LJzye/G2iJJ+BAiLL7jjWn+fmkUFf6sdsJWnTy69dlWf3u1HESvMvu5SujUIzbebt4+R
	 Wjx2nBr6TpJwkw5DxeHDkiKd3SXXyHqjfchXKJ+GPww45OshSlxCz9DoGa2OmDI1/00bd
	 fS4Hf9LM7H+FxE2V/dFpmL5Te2T4s2lrja8cYrm2m/QYjZcnBEGv9So1W/u0XIS1F0YOH
	 ys+iZj6bVloNsLtXFwvss/nVoHAudIlUhunEzO7DKNo/XeT2DuMG74hP16yJX6vE3qkRu
	 86FFAtLgstdrwczrZVlowKmIuQmesn/oy81K13UFAgIXfkr3qUAQum33kqD+2UdPjAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FDCkiP7F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC485606A320
	for <mm-commits@vger.kernel.org>; Fri, 20 Nov 2026 09:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FDCkiP7F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0DA1F000C4;
	Fri, 20 Nov 2026 09:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795165671;
	bh=l/eB1vsONW+011LFr85KTA1f4IN3BjfmOQIagFw6ifw=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=FDCkiP7FABXTW3bawBzuCdNZlPLEsUxFCiAPChyZo1UYIr2YFy44aTbhoQlSXeq/u
	 vtkHlpsY33fwTJuDi2yDRPAgYFyXbpQn0b9LGIRcGhCiJC5backyGCKeYLVWhmXeaK
	 mU5vY3hf6wkmWxr0hmNggiN0Os+PWwnuvpS+eoB8=
Date: Fri, 20 Nov 2026 01:07:50 -0800
To: mm-commits@vger.kernel.org,dram+linux@dram.page,wangruikang@iscas.ac.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261120-update-email-v1-1-b7e080827c7c@iscas.ac.cn>
References: <20261120-update-email-v1-1-b7e080827c7c@iscas.ac.cn>
Subject: + mailmap-update-vivian-wangs-email-address.patch added to mm-nonmm-hotfixes-unstable branch
Message-Id: <20261120090751.2C0DA1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mailmap: update Vivian Wang's email address
has been added to the -mm mm-nonmm-hotfixes-unstable branch.  Its filename is
     mailmap-update-vivian-wangs-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-vivian-wangs-email-address.patch

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
From: Vivian Wang <wangruikang@iscas.ac.cn>
Subject: mailmap: update Vivian Wang's email address
Date: Fri, 20 Nov 2026 16:47:44 +0800

I am leaving ISCAS in December of 2026.  Redirect future mail to my
personal address.

Link: https://patch.msgid.link/20261120-update-email-v1-1-b7e080827c7c@iscas.ac.cn
Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Vivian Wang <dram+linux@dram.page>

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-vivian-wangs-email-address
+++ a/.mailmap
@@ -1020,6 +1020,7 @@ Viresh Kumar <vireshk@kernel.org> <vires
 Viresh Kumar <viresh.kumar@linaro.org> <viresh.kumar@linaro.com>
 Vishnu Dasa <vishnu.dasa@broadcom.com> <vdasa@vmware.com>
 Vivek Aknurwar <quic_viveka@quicinc.com> <viveka@codeaurora.org>
+Vivian Wang <dram+linux@dram.page> <wangruikang@iscas.ac.cn>
 Vivien Didelot <vivien.didelot@gmail.com> <vivien.didelot@savoirfairelinux.com>
 Vlad Dogaru <ddvlad@gmail.com> <vlad.dogaru@intel.com>
 Vladimir Davydov <vdavydov.dev@gmail.com> <vdavydov@parallels.com>
_

Patches currently in -mm which might be from wangruikang@iscas.ac.cn are

mailmap-update-vivian-wangs-email-address.patch

