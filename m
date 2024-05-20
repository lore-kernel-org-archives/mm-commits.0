Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77327E9
	for <mm-commits@vger.kernel.org>; Mon, 20 May 2024 00:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716163966; cv=none; b=kQqyqRuY0dqCedvlhSp/7RSbGhTiMNi8o7mHmnEOV3T7Sy11oZwYu+/slq8uTooLj/Sf6TjdGqDN57lPrRRLj/1kev87/avBuKKbTV6/PNNk+XsEGB6llT+5/jk27gvnw/lhiWIVIAhoP1I2o/5J/EuNA2rZN+ARjzzaMxYOXCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716163966; c=relaxed/simple;
	bh=0kby449tvgT9W0IPHtwb2M+23oyeH2jwEmVoaFQpD5Q=;
	h=Date:To:From:Subject:Message-Id; b=TZT9wbfyOtMAjz3KPCed6Kr76leSfPIupbZoFdyIv0+u55XVwOxFTtt+EsOTsRRnhwM9zwIK3XqvmCVtcpWvJ1p0L+b+Fhxb9dqzx/MZ3usrwKFCZfVz6wezDckXSHSAEbzeLa2YMIj1FPWvnRSxllemIuVbRrEJF9hGVKuMsrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EKvNj5pe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EKvNj5pe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2A5C32781;
	Mon, 20 May 2024 00:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716163966;
	bh=0kby449tvgT9W0IPHtwb2M+23oyeH2jwEmVoaFQpD5Q=;
	h=Date:To:From:Subject:From;
	b=EKvNj5perIO9l6eLaPr74Rem0FnTWn4SaGFwvPmxU8fwVo5KyPf3+n3Rju5GwILgN
	 qJZzT73+U6H3IvwGFYOqBZXjtjDOlK+B4+K+aDCUI6e8g5MullVNEiTXaqAvk4lqW9
	 SZEuwkxmvPomrpMVjm8jvN14GQA05n5kXkyhltn0=
Date: Sun, 19 May 2024 17:12:45 -0700
To: mm-commits@vger.kernel.org,quic_tdas@quicinc.com,quic_jkona@quicinc.com,quic_imrashai@quicinc.com,quic_ajipan@quicinc.com,konrad.dybcio@linaro.org,andersson@kernel.org,quic_skakitap@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-email-address-for-satya-priya.patch added to mm-hotfixes-unstable branch
Message-Id: <20240520001246.4E2A5C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update email address for Satya Priya
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-email-address-for-satya-priya.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-email-address-for-satya-priya.patch

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

mailmap-update-email-address-for-satya-priya.patch

