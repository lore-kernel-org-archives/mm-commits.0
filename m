Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794935340;
	b=C3/alJAAhTzDJ9S2QUB5snlXXcWF2itCTyAlnuMCzkzOV4BA8t2ypqq86qtYzFk5SEH1
	 z1F+V5u1/dWxw8Dk2x6TV7naib0kDR7bXBzVtwWlgBpBMMtKZuXecDgICA6MahWikYFt5
	 g1u9RvZmSGDgO/7/yNPL5ip9v+ODoEWsu9ULgr9UDF3qs9MSAfMDQPKsR6iXzvcIZg8BZ
	 YbvCTF1qCYwhg16tS0058RmUY6AMKDsqwmRNde1S2ta0m3q2pmoensYUYjxPvNaXnzCx0
	 0trNcZKPqszNGmQQkzJufgFsYTgZM/VXj+koU8KO8LSLr64mVILR723ZRaVS7+YRy6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935340;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=afGrLrqpvqcHIfPxb7hm22iis3Is5z3cR1ebLNeG1lw=;
	b=SxvIW/kAn+29UMkGp+/z4IPOLiFSDIJ7HOtMCAJDdiV/Koy57ibEZVEv5wL8CFwlUBt5
	 A3Zhzy8n0HUPbM5F4yGKiAdVAXrAnJRS6ba6OVsxwlqUmjflvjPLGPjtSJgzjon6Qjz5P
	 zpsm9S2TuiHXs7pj7A8QsBBWJqQMiPSfAJoRYWI9Ry0jOdhPw5+2osS3vefsNRYoXFMcW
	 Vx2kWrspuGiFEboVhQA5DIVN6Nmm8JTEY7JGjCJItaKSWPpS25zp0A2x2qXndKEGPvteu
	 fKjchKwvf8Tb6Qg4sh2/XeYFODTNI3YrKNgdhprvhbJ/JeK8WpxfaBCKl3SarFSV0xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=K6s79tHa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8B4606A31C
	for <mm-commits@vger.kernel.org>; Tue, 17 Nov 2026 17:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=K6s79tHa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4DC1F000C5;
	Tue, 17 Nov 2026 17:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794935340;
	bh=afGrLrqpvqcHIfPxb7hm22iis3Is5z3cR1ebLNeG1lw=;
	h=Date:To:From:Subject;
	b=K6s79tHaoqUBoEYOS7h8u69PFh5rwdQZT7opdCLDxm9My3llwZRrFkRxAbdp5wceX
	 t3xw+GrTgUJnurjYDTQ4jcrC+RnCt335eeZMGCD3XznnzB9eLsM5ma7BllgdcU3nKT
	 e+CA+xJCRX3iYKGLWAAqVenDXg0D6jxt4Y5RUrAs=
Date: Tue, 17 Nov 2026 09:08:59 -0800
To: mm-commits@vger.kernel.org,jeff.johnson@oss.qualcomm.com,
	aluvala.sai.teja@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-email-address-for-sai-teja-aluvala.patch added to mm-nonmm-unstable branch
Message-Id: <20261117170900.4E4DC1F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mailmap: update email address for Sai Teja Aluvala
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-update-email-address-for-sai-teja-aluvala.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-email-address-for-sai-teja-aluvala.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Sai Teja Aluvala <aluvala.sai.teja@intel.com>
Subject: mailmap: update email address for Sai Teja Aluvala
Date: Tue, 17 Nov 2026 19:00:08 +0530

Map my former Qualcomm email address to my current Intel email address.

Link: https://lore.kernel.org/20261117133008.2560155-1-aluvala.sai.teja@intel.com
Signed-off-by: Sai Teja Aluvala <aluvala.sai.teja@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-email-address-for-sai-teja-aluvala
+++ a/.mailmap
@@ -838,6 +838,7 @@ Rui Saraiva <rmps@joel.ist.utl.pt>
 Sachin Mokashi <sachin.mokashi@intel.com> <sachinx.mokashi@intel.com>
 Sachin P Sant <ssant@in.ibm.com>
 Sai Prakash Ranjan <quic_saipraka@quicinc.com> <saiprakash.ranjan@codeaurora.org>
+Sai Teja Aluvala <aluvala.sai.teja@intel.com> <quic_saluvala@quicinc.com>
 Sakari Ailus <sakari.ailus@linux.intel.com> <sakari.ailus@iki.fi>
 Sam Protsenko <semen.protsenko@linaro.org>
 Sam Protsenko <semen.protsenko@linaro.org> <semen.protsenko@globallogic.com>
_

Patches currently in -mm which might be from aluvala.sai.teja@intel.com are

mailmap-update-email-address-for-sai-teja-aluvala.patch

