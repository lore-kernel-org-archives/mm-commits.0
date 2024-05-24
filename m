Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E191541C76
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 18:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716576948; cv=none; b=JSJfygJkbuAHrT4kQmqslHO7g2cZrJw9KfkTxZgfEENYdXj1UwwpXS2yyaBNIHABuRDsIqic83dHaE9rSip7NNcRdkUDwHlS0awroHYJDsQXVHRuA0dJ0B4D+IC3SX7xZYFsWLIEmDP8+57DwLkwaacTsl3c7yir7zw4cXLdXE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716576948; c=relaxed/simple;
	bh=4rzi+F5hjyFshXUeOTWBS/ElCNy8SSCrm5AFdRSgYNw=;
	h=Date:To:From:Subject:Message-Id; b=Dc9x7AlG2E08oPoHXFa7lIAvtIybR7WiP9Twvat7B4YVIdVVTYdYPON2f4JX2Ke9xeM8+/MTEMCbALgQVBHsEl9Y44kOH1tJ6tuDxNj0A7pwgSB/V7llhbIbVq2x/VJe7MwjbupEimhgZlhd6TJmkMoEUsOixvpxAa/6WlvAAVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V/W20+DQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V/W20+DQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A776C2BBFC;
	Fri, 24 May 2024 18:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716576947;
	bh=4rzi+F5hjyFshXUeOTWBS/ElCNy8SSCrm5AFdRSgYNw=;
	h=Date:To:From:Subject:From;
	b=V/W20+DQFQW0XjIHzWmYEGzup03GaYDH/Wmp/APAGqjgzEr/RASQrcoHLCtH8Jiys
	 ihC6jXYa7HLieQVlvuSb/+1hq0IRjSIrtwrEOk9cC6DSenroHliqZHZmSHe93AXhyJ
	 mMmqnRw8dNcMHHp9mJQXkT1p2Msz09CPZaSNz0QU=
Date: Fri, 24 May 2024 11:55:46 -0700
To: mm-commits@vger.kernel.org,quic_tdas@quicinc.com,quic_jkona@quicinc.com,quic_imrashai@quicinc.com,quic_ajipan@quicinc.com,konrad.dybcio@linaro.org,andersson@kernel.org,quic_skakitap@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-email-address-for-satya-priya.patch removed from -mm tree
Message-Id: <20240524185547.6A776C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update email address for Satya Priya
has been removed from the -mm tree.  Its filename was
     mailmap-update-email-address-for-satya-priya.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Subject: mailmap: update email address for Satya Priya
Date: Wed, 15 May 2024 11:34:50 +0530

Update mailmap with my latest email ID, quic_c_skakit@quicinc.com
is no longer active.

Link: https://lkml.kernel.org/r/20240515-mailmap-update-v1-1-df4853f757a3@quicinc.com
Signed-off-by: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Cc: Ajit Pandey <quic_ajipan@quicinc.com>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Imran Shaik <quic_imrashai@quicinc.com>
Cc: Jagadeesh Kona <quic_jkona@quicinc.com>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Taniya Das <quic_tdas@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/.mailmap~mailmap-update-email-address-for-satya-priya
+++ a/.mailmap
@@ -572,7 +572,7 @@ Sarangdhar Joshi <spjoshi@codeaurora.org
 Sascha Hauer <s.hauer@pengutronix.de>
 Sahitya Tummala <quic_stummala@quicinc.com> <stummala@codeaurora.org>
 Sathishkumar Muruganandam <quic_murugana@quicinc.com> <murugana@codeaurora.org>
-Satya Priya <quic_c_skakit@quicinc.com> <skakit@codeaurora.org>
+Satya Priya <quic_skakitap@quicinc.com> <quic_c_skakit@quicinc.com> <skakit@codeaurora.org>
 S.Çağlar Onur <caglar@pardus.org.tr>
 Sayali Lokhande <quic_sayalil@quicinc.com> <sayalil@codeaurora.org>
 Sean Christopherson <seanjc@google.com> <sean.j.christopherson@intel.com>
_

Patches currently in -mm which might be from quic_skakitap@quicinc.com are


