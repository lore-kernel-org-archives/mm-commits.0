Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_RED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97132C433ED
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 07:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E8FC613B7
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 07:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbhDFHsg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Apr 2021 03:48:36 -0400
Received: from ozlabs.org ([203.11.71.1]:37805 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232726AbhDFHsf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Apr 2021 03:48:35 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FF0572mQbz9sRf;
        Tue,  6 Apr 2021 17:48:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1617695307;
        bh=hT48Q3+q27wF4pLNLi/jdSFOTGM5eEc6+rWbXZdhUV8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rLb6seP6L+HItog5ZRlQbDlBGgjj5FfFDMp79xIqXSt8RF/75cY8lS+CGMvSfiGUj
         SAQ9j+TdO0nRFqd2vuSNNdU9bCSkStUIitvwgX0LGZJX4Bkgj5FmElsixxpvGkK7PZ
         FKrCFEIU7sZWta+jJ/do0xeNeGxGAEjj46Uy0bE9vcD1R4umsmLVEg2/PayjNpZqGC
         JZLEa8GZoXRyEZoES8l0nS9327QN2m+jmpHuCEW/FQUb1cK4FSy0vBFzDgAmK/2c3s
         pmw8MBL6i5ihrevXDhQr/mj4yVE9NXVwSZkkPXthje8EfCdCbv+bvcbEkI1DlX/ey0
         lOSwDivZP/m4Q==
Date:   Tue, 6 Apr 2021 17:48:26 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     hch@lst.de, mm-commits@vger.kernel.org, npiggin@gmail.com
Subject: Re: + mm-vmalloc-remove-map_kernel_range-fix-2.patch added to -mm
 tree
Message-ID: <20210406174826.73a7ce77@canb.auug.org.au>
In-Reply-To: <20210402001539.gVAnz9ZkV%akpm@linux-foundation.org>
References: <20210402001539.gVAnz9ZkV%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/J1w7Mb5EVz_iDPS0ue7zIiu";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/J1w7Mb5EVz_iDPS0ue7zIiu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 01 Apr 2021 17:15:39 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm-vmalloc-remove-map_kernel_range-fix-2
> has been added to the -mm tree.  Its filename is
>      mm-vmalloc-remove-map_kernel_range-fix-2.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/J1w7Mb5EVz_iDPS0ue7zIiu
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBsEkoACgkQAVBC80lX
0GyHPQf9GwbwJNIRpqV3A6Dg2pU3bdvRVRkeFBDxZjTCCQN3yxjE7GV4Flp27ZWZ
XYkqmLNUBelrAgWEy2m/W6UkF1F1TSkUagZY6AnSRBRCfbpc05BRTUylYdGoToPw
5GhlSh0sVcZxxiGocvCav8zw+gRulcTOPdeESRIuuiIw8MMmqO19wdnqtr2j7N3z
tsVOjBtacS5EKve6XvHWcUAmSO303ok3nBWp3i/O+s1rbCw0sRJfrcsOdv5f4MGh
hrwZyaaWtFzOKwAAJPGNBLcc1vYI+YCScZXNBSqQDGX/J8vuDWO7aCxQdB/EKypW
cTIX9a1aq3iPJRZ+j3ZjufEnKLuotA==
=8o8w
-----END PGP SIGNATURE-----

--Sig_/J1w7Mb5EVz_iDPS0ue7zIiu--
