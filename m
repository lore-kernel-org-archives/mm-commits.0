Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6697E1494D8
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 10:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743675147; cv=none; b=Ebxyg3QOWwkNs9sP/f61PrNzdEVMwPk6JnSXegXwvhFHtvgiWCBRawZUhg9Ap6s6cPPHXUNUMK9HcYf1gXl6ghWyA4UWhNr0XLmJvusC0GBN7o8f/s2YydnwLsAL6qV+nBEBayu6eTSLDt2RYBjNyFMiRHSNfjfhChkUgDfLYgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743675147; c=relaxed/simple;
	bh=B3IBMICb8th1IbbrJ7j9jbFZe3ltnRHSijbunX1eeEQ=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ka/gWDS3XVCZvpeUMlPt9M5KIO51VNW21pbPkRrKHmyxaBffOAavV3M/xjNMV46hCJrxzyQ+pBZkvBdmUdULTxTzuiQzp9+oV+50tQ5X0uSsIRcXO7cdl0fuuH7j/OZbYuA8pfrUYPIoKRfwx7lZsq6mPUc5FnkaEcYEERB59Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FxGMgduB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FxGMgduB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84ACAC4CEE3;
	Thu,  3 Apr 2025 10:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743675146;
	bh=B3IBMICb8th1IbbrJ7j9jbFZe3ltnRHSijbunX1eeEQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FxGMgduBWqynmppswWyLxrv+XYvbcYvdTqrTYDPCVPyK/2k79TfjX4pOK07oaTO6C
	 t/m7kJMcGGhY2xNO+z+WSuLgEaWybVUaulNbDzUpmETPhi4R/ErbWITeSqJEdJQJZf
	 KA4swJp7/wFFfFrP3Q+idmsWDcnL1En3DfEDAFa0=
Date: Thu, 3 Apr 2025 03:12:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
 liam.howlett@oracle.com, jhubbard@nvidia.com, jannh@google.com,
 willy@infradead.org
Subject: Re: + mm-rename-vm_area_struct-to-mm_area.patch added to mm-new
 branch
Message-Id: <20250403031225.a4e00ca1fd7239044254f87e@linux-foundation.org>
In-Reply-To: <aba805fc-1d2c-460e-a197-e00258643a82@lucifer.local>
References: <20250403034145.D5208C4CEDD@smtp.kernel.org>
	<aba805fc-1d2c-460e-a197-e00258643a82@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 3 Apr 2025 10:18:32 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Umm.... :) I think not a coincidence that this was sent on 1st April :P
> 
> Especially if you look at some of the responses I think clear this is the
> sense in which it was received :>) (though - hey - maybe difficult to
> discern parody from reality when it comes to me suggesting
> 3-letter-abbreviated helper structs tbh!)
> 
> So I think best to drop.

Gotcha.
